import asyncio
from datetime import datetime
import math
from typing import List, Tuple
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.interval import IntervalTrigger
import httpx
from config.config import settings
from modules.assets import asset_service
from modules.events.event_repository import write_statement
from shared.dependencies import  get_db
from config.logger_config import logger
from modules.cron.memtable import memtable_dict, Entry
from shared.enums import PriorityLevel

async def process_event_gather(start_point, end_point, session):
    try:
        ips = await asset_service.get_all_ips_in_range(session, start_point, end_point)
        # print(ips)
        str_of_ips = ",".join(ips.keys())
        base_url = f'{settings.external_base_url_events}?ip={str_of_ips}'
        headers = {"Authorization": f"Bearer {settings.external_jwt_token}"}
        async with httpx.AsyncClient() as client:
            gather_time = datetime.now()
            response = await client.get(base_url, headers=headers)
            response.raise_for_status()  
            logger.info(f"Task for range {start_point}-{end_point} completed with status: {response.status_code}")
            events_data = response.json()["data"]["data"]
            key = f'{start_point}-{end_point}'
            sql_data = await format_SQL_statement(events_data,ips,gather_time)
            # print(f'DATA: {sql_data}')

            memtable_dict[key] = Entry(timestamp=datetime.now(), data=sql_data[0], expected_rows=sql_data[1])

    except httpx.RequestError as e:
        logger.error(f"Network error for range {start_point}-{end_point}: {e}")
    except httpx.HTTPStatusError as e:
        logger.error(f"HTTP error for range {start_point}-{end_point}: {e.response.status_code} - {e.response.text}")
    except Exception as e:
        logger.error(f"Unexpected error for range {start_point}-{end_point}: {e}")
    
    return None

async def worker_event_gather(task_queue, worker_id, session):
    while True:
        task = await task_queue.get()
        if task is None:  
            print(f"Worker {worker_id} is stopping.")
            break

        start_point, end_point = task
        print(f"Worker {worker_id} is processing task: {start_point}-{end_point}")
        await process_event_gather(start_point, end_point, session)
        print(f"Worker {worker_id} completed task: {start_point}-{end_point}")
        task_queue.task_done()


async def event_gather_task():
    task_queue = asyncio.Queue()
    workers = []
    sessionDB = next(get_db())
    counted_assets = await asset_service.count_all_assets(sessionDB)
    current_number_of_workers = get_number_of_workers(counted_assets)
    ranges = format_range(counted_assets, current_number_of_workers)

    for start_point, end_point in ranges:
        await task_queue.put((start_point, end_point))

    for worker_id in range(1, current_number_of_workers + 1):  
        workers.append(asyncio.create_task(worker_event_gather(task_queue, worker_id, sessionDB)))

    await task_queue.join()

    for _ in workers:
        await task_queue.put(None)

    test = await asyncio.gather(*workers)
    if len(test) == current_number_of_workers:
        await db_persist_task(memtable_dict)
        task_queue.shutdown()

async def process_db_persist(index_points, session, sql_statement):
    # print("WRITING DATA: ----------------------")
    # print(memtable_dict[index_points].get("data"))
    # print(f'Session is alive: {session.is_active}')
    # print("WRITING DATA: ----------------------")
    await asyncio.sleep(1) # forces the workers to be assigned tasks in case that the workload isnt enough to ensure load distribution
    result = await write_statement(session,memtable_dict[index_points].get("data"), memtable_dict[index_points].get("expected_rows"))
    if result:
        del memtable_dict[index_points]


async def worker_db_persist(task_queue, worker_id, session):
    while True:
        task = await task_queue.get()
        if task is None:  
            print(f"Worker {worker_id} is stopping transaction.")
            break

        index_points = task
        sql_statement = memtable_dict.get(index_points).get("data")
        print(f"Worker {worker_id} is processing task: {index_points} transaction")
        await process_db_persist(index_points, session, sql_statement)
        print(f"Worker {worker_id} completed task: {index_points} transaction")
        task_queue.task_done()


async def db_persist_task(memtable_dict):
    workers = []
    task_queue = asyncio.Queue()
    sessionDB = next(get_db())
    ranges = list(memtable_dict.keys())
    for key in ranges:
        await task_queue.put((key))
    for worker_id in range(0, len(ranges)):
        print("NEW WORKER ID ", worker_id)
        workers.append(asyncio.create_task(worker_db_persist(task_queue, worker_id, sessionDB)))

    await task_queue.join()

    for _ in workers:
        await task_queue.put(None)

    await asyncio.gather(*workers)    
    task_queue.shutdown()


scheduler = BackgroundScheduler()

scheduler.add_job(
    func=lambda: asyncio.run(event_gather_task()),
    trigger=IntervalTrigger(seconds=10),
    id="example_task",
    name="Example task that runs every 5 seconds",
)


def format_range(counted_ips: int, current_number_of_workers: int) -> List[Tuple[int, int]]:
    range_number = math.ceil(counted_ips / current_number_of_workers)
    created_list = []
    for i in range(1, counted_ips, range_number):
        created_list.append((i,  min(i + range_number - 1, counted_ips)))
    return created_list


def get_number_of_workers(counted_assets: int) -> int:
    max_number_of_workers = settings.max_number_of_workers
    min_number_of_workers = settings.min_number_of_workers
    current_number_of_workers = settings.default_number_of_workers  

    if counted_assets / max_number_of_workers <= 1:
        current_number_of_workers = min_number_of_workers
    if counted_assets / max_number_of_workers > max_number_of_workers:
        current_number_of_workers = max_number_of_workers
    else:
        current_number_of_workers = math.ceil(counted_assets / max_number_of_workers)
    return current_number_of_workers


# logic around creation_date and last_occurence might be switched
async def format_SQL_statement(data: list, ip_dict: dict, time_occured) -> tuple[str, int]:
    start = "INSERT INTO Event\n(uuid, status, host, port, priority, category_name, creation_date, last_occurrence, asset_id)\nVALUES\n"
    statement = ""
    end = "AS new_values\nON DUPLICATE KEY UPDATE\nuuid = new_values.uuid,\nstatus = new_values.status,\nlast_occurrence = new_values.last_occurrence;"
    for idx, l in enumerate(data):
        timestamp = l.get('@timestamp')
        received_timestamp = datetime.strptime(timestamp, "%Y-%m-%dT%H:%M:%S.%fZ")
        parsed_timestamp = received_timestamp.strftime("%Y-%m-%d %H:%M:%S.%f")
        event_uuid = l.get('event_uuid')
        ip = l.get('ip')
        port = l.get('port')
        category_name = l.get('category_name')
        urgency = l.get('urgency')
        priority_level = PriorityLevel[urgency].value
        line = f'("{event_uuid}",0,"{ip}","{port}",{priority_level},"{category_name}","{time_occured}","{parsed_timestamp}","{ip_dict[ip]}")'
        if idx < len(data) - 1:
            line += "," 
        statement += (f'{line}\n')

    return start + statement + end, len(data)

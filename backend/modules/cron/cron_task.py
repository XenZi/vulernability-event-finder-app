import asyncio
from datetime import datetime, timedelta
import math
from typing import Dict, List, Tuple
from apscheduler.triggers.date import DateTrigger
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.interval import IntervalTrigger
import httpx
from config.config import settings
from modules.assets import asset_service
from modules.cron import managed_queue
from modules.events.event_repository import write_statement
from shared.api_utils import send_get_request_to_api
from shared.dependencies import  get_db
from config.logger_config import logger
from modules.cron.managed_queue import ManagedQueue
from shared.enums import PriorityLevel
from shared.database_operations_utils import format_SQL_statement;


def format_range(counted_ips: int, current_number_of_workers: int) -> List[Tuple[int, int]]:
    range_number = math.ceil(counted_ips / current_number_of_workers)
    print(f'{range_number} range number')
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


async def process_event_gather(managed_queue, start_point, end_point, session):
    try:
        ips = await asset_service.get_all_ips_in_range(session, start_point, end_point)
        current_date = datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
        date_before = datetime.now() - timedelta(days=7)
        returned_data_from_external_api = await send_get_request_to_api(list(ips.keys()))
        gather_time = datetime.now()
        events_data = returned_data_from_external_api["data"]["data"]
        sql_data = format_SQL_statement(events_data, ips, gather_time)
        key = f'{start_point}-{end_point}'
        await managed_queue.put((key, sql_data))
    except httpx.RequestError as e:
        logger.error(f"Network error for range {start_point}-{end_point}: {e}")
    except httpx.HTTPStatusError as e:
        logger.error(f"HTTP error for range {start_point}-{end_point}: {e.response.status_code} - {e.response.text}")
    except Exception as e:
        logger.error(f"Unexpected error for range {start_point}-{end_point}: {e}")
    
    return None

async def worker_event_gather(producer_queue, consumer_queue, worker_id, session):
    while True:
        task = await producer_queue.get()
        if task is None:  # Sentinel value to stop
            print(f"Worker {worker_id} is stopping.")
            producer_queue.task_done()
            break

        start_point, end_point = task
        print(f"Worker {worker_id} is processing task: {start_point}-{end_point}")
        await process_event_gather(consumer_queue, start_point, end_point, session)
        print(f"Worker {worker_id} completed task: {start_point}-{end_point}")
        producer_queue.task_done()



async def process_db_persist(index_points, session, sql_statement):
    # await asyncio.sleep(1) # forces the workers to be assigned tasks in case that the workload isnt enough to ensure load distribution
    # split_index_points = index_points.split("-")
    try:
        result = await write_statement(session, sql_statement)
        print(f"Result je {result}")
    except Exception as e:
        print(f"{e}")

async def worker_db_persist(persist_queue, worker_id, session):
    while True:
        task = await persist_queue.get()
        if task is None:  # Sentinel value to stop
            print(f"Consumer {worker_id} is stopping.")
            persist_queue.task_done()
            break
        index_points, sql = task
        await process_db_persist(index_points, session, sql)
        # print(test)
        print(f'Index points {index_points} processed by Consumer {worker_id}')
        persist_queue.task_done()


async def event_gather_task():
    producers_queue = asyncio.Queue()
    consumers_queue = asyncio.Queue()
    producers = []
    consumers = []
    sessionDB = next(get_db())
    counted_assets = await asset_service.count_all_assets(sessionDB)
    current_number_of_workers = get_number_of_workers(counted_assets)
    ranges = format_range(counted_assets, current_number_of_workers)

    for start_point, end_point in ranges:
        await producers_queue.put((start_point, end_point))

    for i in range (current_number_of_workers):
        await producers_queue.put(None)

    for worker_id in range(1, current_number_of_workers + 1):
        producers.append(asyncio.create_task(worker_event_gather(producers_queue, consumers_queue, worker_id, sessionDB)))

    # Start consumer workers
    for consumer_id in range(1, current_number_of_workers + 1):
        consumers.append(asyncio.create_task(worker_db_persist(consumers_queue, consumer_id, sessionDB)))
    print("All consumer tasks have been started.")

    print("Waiting for all producer tasks to finish...")
    await producers_queue.join()
    print("All producer tasks have finished.")

    for _ in range(current_number_of_workers):
        await consumers_queue.put(None) 

    await consumers_queue.join()

    print("All tasks are done finally")


scheduler = BackgroundScheduler()

scheduler.add_job(
    func=lambda: asyncio.run(event_gather_task()),
    trigger=DateTrigger(run_date=datetime.now()),
    id="example_task",
    name="Example task that runs only once",
)

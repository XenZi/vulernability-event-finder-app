import asyncio
import math
from typing import List, Tuple
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.interval import IntervalTrigger
import httpx
from config.config import settings
from modules.assets import asset_service
from shared.dependencies import  get_db
from config.logger_config import logger

async def process_event(start_point, end_point, session):
    try:
        ips = await asset_service.get_all_ips_in_range(session, start_point, end_point)
        print(ips)
        str_of_ips = ",".join(ips)
        base_url = f'{settings.external_base_url_events}?ip={str_of_ips}'
        headers = {"Authorization": f"Bearer {settings.external_jwt_token}"}
        async with httpx.AsyncClient() as client:
            response = await client.get(base_url, headers=headers)
            response.raise_for_status()  
            logger.info(f"Task for range {start_point}-{end_point} completed with status: {response.status_code}")
            # print(response.json())
    except httpx.RequestError as e:
        logger.error(f"Network error for range {start_point}-{end_point}: {e}")
    except httpx.HTTPStatusError as e:
        logger.error(f"HTTP error for range {start_point}-{end_point}: {e.response.status_code} - {e.response.text}")
    except Exception as e:
        logger.error(f"Unexpected error for range {start_point}-{end_point}: {e}")
    
    return None



async def worker(task_queue, worker_id, session):
    while True:
        task = await task_queue.get()
        if task is None:  
            print(f"Worker {worker_id} is stopping.")
            break

        start_point, end_point = task
        print(f"Worker {worker_id} is processing task: {start_point}-{end_point}")
        await process_event(start_point, end_point, session)
        print(f"Worker {worker_id} completed task: {start_point}-{end_point}")
        task_queue.task_done()


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


async def example_task():
    task_queue = asyncio.Queue()
    workers = []
    sessionDB = next(get_db())
    counted_assets = await asset_service.count_all_assets(sessionDB)
    current_number_of_workers = get_number_of_workers(counted_assets)
    ranges = format_range(counted_assets, current_number_of_workers)

    for start_point, end_point in ranges:
        await task_queue.put((start_point, end_point))

    for worker_id in range(1, current_number_of_workers + 1):  
        workers.append(asyncio.create_task(worker(task_queue, worker_id, sessionDB)))

    await task_queue.join()

    for _ in workers:
        await task_queue.put(None)

    await asyncio.gather(*workers)
    print("All tasks completed")

def format_range(counted_ips: int, current_number_of_workers: int) -> List[Tuple[int, int]]:
    range_number = math.ceil(counted_ips / current_number_of_workers)
    created_list = []
    for i in range(1, counted_ips, range_number):
        created_list.append((i,  min(i + range_number - 1, counted_ips)))
    return created_list

scheduler = BackgroundScheduler()

scheduler.add_job(
    func=lambda: asyncio.run(example_task()),
    trigger=IntervalTrigger(seconds=3),
    id="example_task",
    name="Example task that runs every 10 seconds",
)


from asyncio import Semaphore
import asyncio
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.interval import IntervalTrigger
from config.logger_config import logger
from shared.dependencies import SessionDep
from sqlalchemy.orm import Session

def example_task():
    events = ["123", "456", "789"]
    tasks = [process_event(event) for event in events]
    results = asyncio.gather(*tasks)
    print(results)
scheduler = BackgroundScheduler()


scheduler.add_job(
    func=example_task,
    trigger=IntervalTrigger(seconds=10),
    id="example_task",
    name="Example task that runs every 10 seconds",
)



semaphore = Semaphore(5)

async def process_event(event):
        async with semaphore:
            # Simulated processing
            print(f"Processing event: {event['event_uuid']}")
            await asyncio.sleep(1)  # Simulate delay
            # Insert/upsert logic here if needed
            return {"uuid": event["event_uuid"], "status": "processed"}

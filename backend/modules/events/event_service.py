from datetime import datetime
from shared.enums import EventStatus
from modules.events import event_repository
from modules.events.events_schemas import Event, EventUpdateDTO
from shared.dependencies import Session
from shared.exceptions import DatabaseFailedOperation, EntityNotFound
from shared.database_operations_utils import format_sql_for_single_asset
from shared.api_utils import send_get_request_for_single


async def get_event_by_id(session: Session, event_id: int) -> Event:
    event: Event | None = await event_repository.get_event_by_id(session, event_id)
    if event is None:
        raise EntityNotFound(404, 'Entity not found')
    return event

async def get_event_by_uuid(event_UUID: str):
    data = await send_get_request_for_single(event_UUID)
    event_data = data['data']['data']
    return event_data

async def update_event_by_id(session: Session, event: EventUpdateDTO):
    print(event)
    await event_repository.update_event_status(session,event)
    



async def create_event(session: Session, createdEvent: list, asset_id: int) -> bool:
    created_statement = format_sql_for_single_asset(createdEvent, asset_id, datetime.now())
    event: bool = await event_repository.write_statement(session, created_statement)
    if event is None:
        raise DatabaseFailedOperation(500, "Database failed")
    return event

async def get_all_events_by_asset_id(session: Session, asset_id: int) -> list[Event]:
    events = await event_repository.get_all_events_by_asset_id(session, asset_id)
    return events

async def get_sorted_filtered_events(session: Session, asset_id: int, sort_by: str, order: str) -> list[Event]:
        events = await event_repository.get_sorted_events_for_asset(session,asset_id,sort_by,order)
        return events


async def get_filtered_events(session: Session, asset_id, filter_value):
        int_val = EventStatus[filter_value].value
        print(int_val)
        events = await event_repository.get_filtered_events_for_asset(session,asset_id,int_val)
        return events

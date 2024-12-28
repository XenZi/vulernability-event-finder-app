from datetime import datetime
from modules.events import event_repository
from modules.events.events_schemas import Event, ReceivedEvent
from shared import database_operations_utils
from shared.dependencies import Session
from shared.exceptions import DatabaseFailedOperation, EntityNotFound
from shared.database_operations_utils import format_sql_for_single_asset


async def get_event_by_id(session: Session, event_id: int) -> Event:
    event: Event | None = await event_repository.get_event_by_id(session, event_id)
    if event is None:
        raise EntityNotFound(404, 'Entity not found')
    return event


async def create_event(session: Session, createdEvent: list, asset_id: int) -> bool:
    created_statement = format_sql_for_single_asset(createdEvent, asset_id, datetime.now())
    event: bool = await event_repository.write_statement(session, created_statement)
    if event is None:
        raise DatabaseFailedOperation(500, "Database failed")
    return event
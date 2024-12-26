from modules.events import event_repository
from modules.events.events_schemas import Event
from shared.dependencies import Session
from shared.exceptions import EntityNotFound



async def get_event_by_id(session: Session, event_id: int) -> Event:
    event: Event | None = await event_repository.get_event_by_id(session, event_id)
    if event is None:
        raise EntityNotFound(404, 'Entity not found')
    return event



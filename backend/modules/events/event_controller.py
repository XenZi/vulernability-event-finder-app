from fastapi import APIRouter, Query, status

from modules.events import event_service
from modules.events.events_schemas import Event
from shared.dependencies import SessionDep, CurrentUser

router = APIRouter(prefix="/events")


@router.get("/{id}", response_model=Event, status_code=status.HTTP_200_OK)
async def get_event_by_id(session: SessionDep, current_user: CurrentUser, id: int) -> Event:
    return await event_service.get_event_by_id(session=session, event_id=id)
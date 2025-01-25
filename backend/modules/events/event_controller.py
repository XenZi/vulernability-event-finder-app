from fastapi import APIRouter, status

from modules.events import event_service
from modules.events.events_schemas import Event
from shared.dependencies import SessionDep, CurrentUser

router = APIRouter(prefix="/events")


@router.get("/{id}", response_model=Event, status_code=status.HTTP_200_OK)
async def get_event_by_id(session: SessionDep, current_user: CurrentUser, id: int) -> Event:
    return await event_service.get_event_by_id(session=session, event_id=id)


@router.get("/asset_id/{id}", response_model=list[Event], status_code=status.HTTP_200_OK)
async def get_all_events_by_asset_id(session: SessionDep, id: int) -> list[Event]:
    return await event_service.get_all_events_by_asset_id(session, id)


@router.get("/asset_id/sorted/{asset_id}/{sort_by}/{order}/{filter_by}/{filter_value}", response_model=list[Event], status_code=status.HTTP_200_OK)
async def get_all_events_by_asset_id(session: SessionDep, asset_id: int, sort_by: str, order: str, filter_by,  filter_value) -> list[Event]:
    return await event_service.get_sorted_filtered_events(session, asset_id, sort_by, order, filter_by, filter_value)


@router.get("/uuid/{uuid}", status_code=status.HTTP_200_OK)
async def get_event_data(uuid: str):
    return await event_service.get_event_by_uuid(event_UUID=uuid)
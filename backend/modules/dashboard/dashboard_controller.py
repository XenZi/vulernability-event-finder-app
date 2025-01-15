from fastapi import APIRouter

from modules.dashboard import dashboard_service
from shared.dependencies import SessionDep, CurrentUser
router = APIRouter(prefix="/dashboard")



@router.get("/priorities")
async def get_events_by_priority(session: SessionDep, current_user: CurrentUser) -> dict:
    return await dashboard_service.get_events_by_priority(session=session, current_user=current_user)


@router.get("/categories")
async def get_events_by_category(session: SessionDep, current_user: CurrentUser) -> dict:
    return await dashboard_service.get_events_by_category(session=session, current_user=current_user)

@router.get("/by-month")
async def get_number_of_events_by_month(session: SessionDep, current_user: CurrentUser) -> list[dict]:
    return await dashboard_service.get_number_of_events_by_month(session=session, current_user=current_user)

# @router.get("/heatmap")
# async def get_events_heatmap(session: SessionDep, current_user: CurrentUser) -> dict:
#     return await dashboard_service.get_events_heatmap(session=session, current_user=current_user)


# @router.get("/notification-priority")
# async def get_notification_priority_distribution(session: SessionDep, current_user: CurrentUser) -> dict:
#     return await dashboard_service.get_notification_priority_distribution(session=session, current_user=current_user)

# @router.get("/top-hosts")
# async def get_top_hosts(session: SessionDep, current_user: CurrentUser) -> dict:
#     return await dashboard_service.get_top_hosts(session=session, current_user=current_user)

# @router.get("/recent-updates")
# async def get_recent_events(session: SessionDep, current_user: CurrentUser) -> dict:
#     return await dashboard_service.get_recent_events(session=session, current_user=current_user)

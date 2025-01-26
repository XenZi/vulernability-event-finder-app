from http.client import HTTPException
from fastapi import APIRouter, status

from modules.notifications import notification_service
from modules.notifications.notifications_schemas import NotificationInfo, NotificationUpdateDTO
from shared.dependencies import SessionDep, CurrentUser

router = APIRouter(prefix="/notifications")

@router.get("/user_notifications/", response_model=list[NotificationInfo], status_code=status.HTTP_200_OK)
async def get_notifications_for_user(session: SessionDep, current_user: CurrentUser) -> list[NotificationInfo]:
    return await notification_service.get_user_notifications(session, current_user.id)

@router.put("/user_notifications/all/", status_code=status.HTTP_200_OK)
async def update_all_user_notifications(session: SessionDep, current_user: CurrentUser):
    return await notification_service.update_all_user_notifications(session, current_user)

@router.put("/user_notifications/single/", status_code=status.HTTP_200_OK)
async def update_user_notification(session: SessionDep, notificationDTO: NotificationUpdateDTO, current_user: CurrentUser):
    return await notification_service.update_notification(session,notificationDTO,current_user)


@router.get("/user_notifications/get_data/", status_code=status.HTTP_200_OK)
async def get_notifications_for_user(session: SessionDep) -> list[NotificationInfo]:
    await notification_service.get_data(session)


from pydantic import BaseModel

class NotificationRequest(BaseModel):
    token: str
    title: str
    body: str

@router.post("/send_notification")
async def send_notification(request: NotificationRequest):
    try:
        print(f'{request.token}, {request.title}, {request.body}')
        response = notification_service.send_push_notification(request.token, request.title, request.body)
        return {"message": "Notification sent", "response": response}
    except Exception as e:
        raise HTTPException(status_code=422, detail=str(e))
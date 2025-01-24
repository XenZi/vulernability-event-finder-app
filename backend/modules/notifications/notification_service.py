from requests import Session
from modules.notifications import notification_repository
from modules.notifications.notifications_schemas import Notification, NotificationUpdateDTO
from modules.user.user_schemas import UserDTO
from shared.exceptions import DatabaseFailedOperation, DuplicateEntity, Unauthorized
from shared.database_operations_utils import format_sql_for_notifications


async def get_user_notifications(session: Session, user_id: int) -> list[Notification]:
    notifications = await notification_repository.get_user_notifications(session, user_id)
    if not notifications:
        return []
    return notifications

async def create_notifications(session: Session):
    print("Writing notifications")
    notification_data = await notification_repository.get_all_events_for_notification(session)
    statement = format_sql_for_notifications(notification_data)
    try:
        await notification_repository.write_statement(session, statement)
        print("DONE WRITING NOTIFICATIONS")
    except DuplicateEntity as e:
        print("ERROR 1")
        print(e)
        raise e  
    except Exception as e:
        print("ERROR 2")
        print(e)
        raise DatabaseFailedOperation(500, f"Unexpected error during notification creation: {str(e)}")

async def update_notification(session: Session, notification: NotificationUpdateDTO, user: UserDTO) -> Notification:
    if notification.user_id != user.id:
        raise Unauthorized(401, 'Unauthorized')
    result = await notification_repository.update_user_notification(session=session, notification=notification)
    return result

async def update_all_user_notifications(session: Session, user: UserDTO):
    result = await notification_repository.update_all_user_notifications(session, user)
    if not result:
        return []
    return result



import asyncio
from config.logger_config import logger
from firebase_admin import messaging
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

async def gather_notifications_for_push(session: Session) -> list[str]:
    result = await notification_repository.get_all_notifications_for_push(session)
    print(result)
    print("OVO JE SVE")
    return result


async def send_user_notifications(token_list):
    print()
    try:
        limited_size_list = chunk_list(token_list)
        failed_list = []
        print(limited_size_list)
        for chunk in limited_size_list:
            print(chunk)
            await asyncio.sleep(1)
            message = messaging.MulticastMessage(
            notification=messaging.Notification(
                title="Discovered Events",
                body="Your assets have non-acknoledged events xD",
                ),
            tokens=chunk
            )
            
            response = messaging.send_each_for_multicast(message)
            success_count = response.success_count
            failure_count = response.failure_count
            logger.info(f'Successfuly sent: {success_count}, failed to send: {failure_count}')
            failed_tokens = [result.token for result in response.responses if not result.success]
            failed_list = [*failed_list, *failed_tokens]
        if len(failed_list) != 0:
            await send_user_notifications(failed_list)
    except Exception as e:
        print(f"Unexpected error: {e}")



async def send_push_notification(token: str, title: str, body: str):
    # Create the message payload
    print("sending notification")
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body,
        ),
        token=token,  # This is the FCM token of the target device
    )

    # Send the message
    response = messaging.send(message)
    return response


def chunk_list(input_list, chunk_size=500):
    return [input_list[i:i + chunk_size] for i in range(0, len(input_list), chunk_size)]

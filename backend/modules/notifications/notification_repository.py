from http.client import HTTPException
from config.logger_config import logger
from requests import Session
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from modules.notifications.notifications_schemas import Notification, NotificationData, NotificationUpdateDTO
from modules.user.user_schemas import UserDTO
from shared.exceptions import DatabaseFailedOperation


async def get_user_notification(session: Session, user_id: int) -> list[Notification]:
    try:
        select_query = text("""SELECT * FROM Notification n WHERE n.user_id=:user_id AND seen=FALSE""")
        result = session.execute(select_query, {"user_id":user_id}).fetchall()

        if not result:
            return []
        
        notifications = [Notification(**row._mapping) for row in result]
        return notifications
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")


async def write_statement(session: Session, statement: str) -> bool:
    try:
        logger.info("Writing statment to DB")
        
        insert_query = text(statement)
        result = session.execute(insert_query)
        session.commit()

        return True
    except SQLAlchemyError as e:
        session.rollback()
        raise HTTPException(500, f"Database error: {str(e)}")
    except Exception as e:
        session.rollback()
        raise HTTPException(500, f"Unexpected error: {str(e)}")

async def update_all_user_notifications(session: Session, user: UserDTO):
    try:
        update_query = text("""
            UPDATE Notification n
            SET seen=:seen
            WHERE n.user_id=:user_id     
        """)
        result = session.execute(update_query, {
            "seen": True,
            "user_id": user.id
        })
        session.commit()
    except SQLAlchemyError as e:
        session.rollback()
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        session.rollback()
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")

async def update_user_notification(session: Session, notification: NotificationUpdateDTO):
    try:
        update_query = text("""
            UPDATE Notification n
            SET seen=:seen
            WHERE n.id=:id    
        """)
        result = session.execute(update_query, {
            "seen": True,
            "id": notification.id
        })
        notification.seen=True
        session.commit()
        return notification
    except SQLAlchemyError as e:
        session.rollback()
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        session.rollback()
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")
    

async def get_all_events_for_notification(session: Session) -> list:
    try:
        # switch to discovered status e.status = 0
        # today = datetime.now()
        # notification_date = str(datetime.date(today))

        
        select_query = text("""
            SELECT 
            u.id as user_id,
            u.fcm_token as fcm_token,
            a.id AS asset_id, 
            a.ip AS asset_ip, 
            COUNT(e.id) AS event_count 
            FROM Event e
            INNER JOIN Asset a ON e.asset_id = a.id     
            INNER JOIN User u ON u.id = a.user_id       
            WHERE 
            e.status = 0 
            AND e.priority >= a.notification_priority_level
            GROUP BY a.id, a.ip 
            LIMIT 50000; 
        """)
        result = session.execute(select_query).fetchall()
    
        notification_data = [NotificationData(**row._mapping) for row in result]    
        if not result:
            return []
        return notification_data
    except SQLAlchemyError as e:

        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        print(f'ERROR {e}')
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")
        
async def get_all_notifications_for_push(session: Session) -> list[str]:
    try:

        select_query = text("""
            SELECT DISTINCT fcm_token FROM Notification WHERE seen = 0 limit 100000;
        """)
        result = session.execute(select_query).fetchall()
        print("OVDE JE PUKO")
        notification_list = [row[0] for row in result if row[0] and row[0].strip()]
        print(notification_list)
        if not result:
            return []
        return notification_list

    except SQLAlchemyError as e:

        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        print(f'ERROR {e}')
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")
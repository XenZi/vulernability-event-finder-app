
from datetime import datetime
from http.client import HTTPException
from modules.events.events_schemas import Event, ReceivedEvent
from shared.dependencies import Session
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from config.logger_config import logger

from shared.enums import EventStatus, PriorityLevel
from shared.exceptions import DatabaseFailedOperation


async def create_new_event(session: Session, receivedEvent: ReceivedEvent, asset_id: int) -> Event | None:
    try:
        insert_query = text("""
            INSERT INTO Event (uuid, status, host, port, priority, category_name, last_occurrence, asset_id)
            VALUES (
                :uuid,
                :status,
                :host,
                :port,
                :priority,
                :category_name,
                :last_occurrence,
                :asset_id
            )
            ON DUPLICATE KEY UPDATE
                last_occurrence = GREATEST(last_occurrence, VALUES(last_occurrence));
        """)

        session.execute(insert_query, {
            "uuid": receivedEvent.event_uuid,
            "status": EventStatus.Discovered.value,  # Assuming Enum values are integers
            "host": receivedEvent.ip,
            "port": receivedEvent.port,
            "priority": PriorityLevel[receivedEvent.urgency.title()].value,  # Ensure title matches Enum keys
            "category_name": "",  # Empty string as default
            "last_occurrence": datetime.datetime.now(),  # Use actual datetime instance
            "asset_id": asset_id,
        })
        session.commit()  # Commit changes to persist in the database
    except SQLAlchemyError as e:
        session.rollback()  # Rollback transaction on error
        raise HTTPException(500, f"Database error: {str(e)}")
    except Exception as e:
        raise HTTPException(500, f"Unexpected error: {str(e)}")

async def get_event_by_id(session: Session, asset_id: int) -> Event | None:
    try: 
        select_query = text("""SELECT * FROM Event WHERE id=:id LIMIT 1""")
        result = session.execute(select_query, {"id": asset_id}).first()
        if not result:
            return None
        result_dict = dict(result._mapping)
        return Event(**result_dict)
    except SQLAlchemyError as e:
        raise HTTPException(500, f"Database error: {str(e)}")
    except Exception as e:
        raise HTTPException(500, f"Unexpected error: {str(e)}")
    

async def get_all_events_by_asset_id(session: Session, asset_id: int, page: int = 1, page_size: int = 10) -> list[Event]:
    try:
        if page < 1 or page_size < 1:
            raise HTTPException(400, "Page and page size must be positive integers.")
        
        offset = (page - 1) * page_size
        select_query = text("""SELECT * FROM event WHERE asset_id=:id LIMIT :limit OFFSET :offset""")
        result = session.execute(select_query, {"id": asset_id, "limit": page_size, "offset": offset}).fetchall()

        if not result:
            return []
        
        assets = [Event(**row._mapping) for row in result]
        return assets
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")
    
async def get_all_events_for_notification(session: Session) -> set:
    try:
        today = datetime.now()
        notification_date = str(datetime.date(today))

        
        select_query = text("""SELECT DISTINCT u.email FROM Event e INNER JOIN Asset a ON e.asset_id = a.id INNER JOIN User u ON u.id = a.user_id WHERE e.updated_at = :notification_date AND e.priority >= a.notification_priority_level LIMIT 50000;""")
        result = session.execute(select_query, {"notification_date": notification_date}).fetchall()

        users_set = {row[0] for row in result}        
        if not result:
            return []
        return users_set
    except SQLAlchemyError as e:
    
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        print(f'ERROR {e}')
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
   



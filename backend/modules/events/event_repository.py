
from http.client import HTTPException
from modules.events.events_schemas import Event
from shared.dependencies import Session
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError

from shared.exceptions import DatabaseFailedOperation

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

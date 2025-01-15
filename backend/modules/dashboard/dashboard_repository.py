from http.client import HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import text
from sqlalchemy.exc import IntegrityError, SQLAlchemyError
from shared.exceptions import DatabaseFailedOperation, DuplicateEntity, Unauthorized



async def count_events_priority(session: Session, user_id: int) -> dict:
    try:
        select_query = text("""
        SELECT 
            e.priority AS priority_level, 
            COUNT(*) AS event_count
        FROM Event e
        INNER JOIN Asset a ON e.asset_id = a.id
        WHERE a.user_id = :user_id
        GROUP BY e.priority
        ORDER BY e.priority;
        """)
        result = session.execute(select_query, {"user_id": user_id}).fetchall()

        if not result:
            return {}

        return {row[0]: row[1] for row in result}
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")
    

async def get_events_by_category(session: Session, user_id: int) -> dict:
    try:
        select_query = text("""
        SELECT 
            e.category_name, 
            COUNT(*) AS event_count
        FROM Event e
        INNER JOIN Asset a ON e.asset_id = a.id
        WHERE a.user_id = :user_id
        GROUP BY e.category_name
        ORDER BY event_count DESC
        """)
        result = session.execute(select_query, {"user_id": user_id}).fetchall()

        if not result:
            return {}

        return {row[0]: row[1] for row in result}
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")
    

async def get_events_heatmap(session: Session, user_id: int) -> dict:
    try:
        select_query = text("""
        SELECT 
            e.priority AS priority_level,
            e.status,
            COUNT(*) AS event_count
        FROM Event e
        INNER JOIN Asset a ON e.asset_id = a.id
        WHERE a.user_id = :user_id
        GROUP BY e.priority, e.status
        ORDER BY e.priority, e.status
        """)
        result = session.execute(select_query, {"user_id": user_id}).fetchall()

        if not result:
            return {}

        return {row[0]: row[1] for row in result}
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")
    

async def get_notification_priority_distribution(session: Session, user_id: int) -> dict:
    try:
        select_query = text("""
        SELECT notification_priority_level, COUNT(*) AS asset_count
        FROM Asset
        WHERE user_id = :user_id
        GROUP BY notification_priority_level
        ORDER BY notification_priority_level
        """)
        result = session.execute(select_query, {"user_id": user_id}).fetchall()

        if not result:
            return {}

        return {row[0]: row[1] for row in result}
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")

async def get_top_hosts(session: Session, user_id: int) -> dict:
    try:
        select_query = text("""
        SELECT e.host, COUNT(*) AS event_count
        FROM Event e
        INNER JOIN Asset a ON e.asset_id = a.id
        WHERE a.user_id = :user_id
        GROUP BY e.host
        ORDER BY event_count DESC
        LIMIT 5
        """)
        result = session.execute(select_query, {"user_id": user_id}).fetchall()

        if not result:
            return {}

        return {row[0]: row[1] for row in result}
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")
    

async def get_recent_events(session: Session, user_id: int) -> dict:
    try:
        select_query = text("""
        SELECT e.id AS event_id, e.updated_at, e.last_occurrence
        FROM Event e
        INNER JOIN Asset a ON e.asset_id = a.id
        WHERE a.user_id = :user_id
        ORDER BY e.updated_at DESC
        LIMIT 10
        """)
        result = session.execute(select_query, {"user_id": user_id}).fetchall()

        if not result:
            return {"data": []}

        return {"data": [{"event_id": row[0], "updated_at": row[1], "last_occurrence": row[2]} for row in result]}
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")


async def get_number_of_events_by_month(session: Session, user_id: int) -> list[dict]:
    try:
        select_query = text("""
        SELECT 
            DATE_FORMAT(e.creation_date, '%Y-%m') AS event_month, 
            COUNT(*) AS event_count
        FROM 
            Event e
        INNER JOIN 
            Asset a ON e.asset_id = a.id
        WHERE 
            a.user_id = :user_id
        GROUP BY 
            DATE_FORMAT(e.creation_date, '%Y-%m')
        ORDER BY 
            event_month;
        """)
        result = session.execute(select_query, {"user_id": user_id}).fetchall()

        if not result:
            return []

        # Convert the result to a list of dictionaries
        return [{"event_month": row[0], "event_count": row[1]} for row in result]
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")

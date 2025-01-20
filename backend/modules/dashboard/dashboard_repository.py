from datetime import datetime, timedelta
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

async def get_top_hosts(session: Session, user_id: int) -> list:
    try:
        select_query = text("""
        SELECT 
            a.id AS id, 
            e.host, 
            COUNT(*) AS event_count
        FROM 
            Event e
        INNER JOIN 
            Asset a 
            ON e.asset_id = a.id
        WHERE 
            a.user_id = :user_id
        GROUP BY 
            a.id, e.host
        ORDER BY 
            event_count DESC
        LIMIT 5;
        """)
        result = session.execute(select_query, {"user_id": user_id}).fetchall()

        if not result:
            return []

        # Transform the result into a list of objects
        return [{"id": row[0], "host": row[1], "event_count": row[2]} for row in result]
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")
    

async def get_recent_events(session: Session, user_id: int) -> dict:
    try:
        select_query = text("""
        SELECT e.id AS event_id, e.priority, e.category_name
        FROM Event e
        INNER JOIN Asset a ON e.asset_id = a.id
        WHERE a.user_id = :user_id
        ORDER BY e.updated_at DESC
        LIMIT 5
        """)
        result = session.execute(select_query, {"user_id": user_id}).fetchall()

        if not result:
            return {"data": []}

        return {"data": [{"event_id": row[0], "priority": row[1], "category_name": row[2]} for row in result]}
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")


async def get_number_of_events_by_month(session: Session, user_id: int) -> list[dict]:
    try:
        # Fetch data for the last 6 months from the database
        six_months_ago = (datetime.now() - timedelta(days=6*30)).strftime("%Y-%m-%d")
        select_query = text("""
        SELECT 
            DATE_FORMAT(e.creation_date, '%Y-%m') AS event_month, 
            COUNT(*) AS event_count
        FROM 
            Event e
        INNER JOIN 
            Asset a ON e.asset_id = a.id
        WHERE 
            a.user_id = :user_id AND e.creation_date >= :six_months_ago
        GROUP BY 
            DATE_FORMAT(e.creation_date, '%Y-%m')
        ORDER BY 
            event_month;
        """)
        result = session.execute(select_query, {"user_id": user_id, "six_months_ago": six_months_ago}).fetchall()

        # Convert the result to a dictionary for easy lookup
        event_counts = {row[0]: row[1] for row in result}

        # Calculate the last 6 months in '%Y-%m' format
        current_date = datetime.now()
        last_6_months = [
            (current_date - timedelta(days=30 * i)).strftime("%Y-%m")
            for i in range(6)
        ][::-1]  # Reverse to get chronological order

        # Include all months and fill missing ones with 0
        final_result = []
        for month in last_6_months:
            final_result.append({
                "event_month": month,
                "event_count": event_counts.get(month, 0)
            })

        return final_result

    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")

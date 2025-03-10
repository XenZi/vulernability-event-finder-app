from typing import Dict
from modules.assets.asset_schemas import Asset, AssetDTO
from http.client import HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import text
from sqlalchemy.exc import IntegrityError, SQLAlchemyError
from shared.exceptions import DatabaseFailedOperation, DuplicateEntity, Unauthorized

async def create_asset(session: Session, asset: Asset) -> AssetDTO:
    try:
        insert_query = text("""
            INSERT INTO Asset (ip, notification_priority_level, creation_date, user_id)
            VALUES (:ip, :notification_priority_level, :creation_date, :user_id)
        """)

        session.execute(insert_query, {
            "ip": asset.ip,
            "notification_priority_level": asset.notification_priority_level.value,
            "creation_date": asset.creation_date,
            "user_id": asset.user.id if asset.user else 0
        })

        last_insert_id = session.execute(text("SELECT LAST_INSERT_ID()")).scalar()
        if not last_insert_id:  
            session.rollback()  
            raise HTTPException(500, "Error while inserting into the database")

        session.commit()

        return AssetDTO(
              id=last_insert_id,
              ip=asset.ip,
              notification_priority_level=asset.notification_priority_level,
              creation_date=asset.creation_date,
              user_id=asset.user.id
        )
    except IntegrityError as e:
        session.rollback()
        if e.orig and e.orig.args[0] == 1062:
            raise DuplicateEntity(400, "Entity already exists")
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        session.rollback()
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")

# does not populate user field in asset
# probably because of lack of join
async def get_asset_by_id(session: Session, asset_id: int, user_id: int) -> AssetDTO | None:
    try: 
        select_query = text("""SELECT * FROM Asset WHERE id=:id LIMIT 1""")
        result = session.execute(select_query, {"id": asset_id, "user_id": user_id}).first()
        if not result:
            return None
        result_dict = dict(result._mapping)
        return AssetDTO(**result_dict)
    except SQLAlchemyError as e:
        raise HTTPException(500, f"Database error: {str(e)}")
    except Exception as e:
        raise HTTPException(500, f"Unexpected error: {str(e)}")

async def get_all_assets_for_user(
    session: Session,
    user_id: int,
    page: int = 1,
    page_size: int = 10,
    order_by: str = "creation_date",
    order_by_criteria: str = "ASC",
) -> list[AssetDTO]:
    try:
        # Validate input
        if page < 1 or page_size < 1:
            raise HTTPException(400, "Page and page size must be positive integers.")
        
        
        offset = (page - 1) * page_size

        query = f"""
            SELECT * FROM asset
            WHERE user_id = :id
            ORDER BY {order_by} {order_by_criteria}
            LIMIT :limit OFFSET :offset
        """
        select_query = text(query)
        
        # Execute the query
        result = session.execute(select_query, {"id": user_id, "limit": page_size, "offset": offset}).fetchall()
        
        if not result:
            return []
        
        # Map the result to AssetDTO
        assets = [AssetDTO(**row._mapping) for row in result]
        return assets
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")

async def update_notification_priority_level(session: Session, asset: AssetDTO) -> AssetDTO:
    try:
        update_query = text("""
            UPDATE Asset
            SET notification_priority_level = :new_priority_level
            WHERE id = :asset_id;
        """)
        result = session.execute(update_query, {
            "new_priority_level": asset.notification_priority_level.value,
            "asset_id": asset.id,
            "user_id": asset.user_id 
        })
        session.commit()  
        return asset
    except SQLAlchemyError as e:
        session.rollback()
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        session.rollback()
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")

async def delete_asset(session: Session, asset_id: int, user_id: int):
    try:
        delete_query = text("""
        DELETE FROM asset
        WHERE id=:asset_id AND user_id=:user_id
        """)
        result = session.execute(delete_query, {
            "asset_id": asset_id,
            "user_id": user_id
        })

        # may fail if asset_id is wrong, which isnt an authorization fail, but less likely
        if result.rowcount == 0: # type: ignore
            raise Unauthorized(401, "Delete failed, unauthorized")

        session.commit()
    except SQLAlchemyError as e:
        session.rollback()
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        session.rollback()
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")

async def get_all_assets(session: Session, page: int = 1, page_size: int = 10) -> list[AssetDTO]:
    try:
        if page < 1 or page_size < 1:
            raise HTTPException(400, "Page and page size must be positive integers.")

        offset = (page - 1) * page_size
        select_query = text("""SELECT * FROM asset LIMIT :limit OFFSET :offset""")
        result = session.execute(select_query, {"limit": page_size, "offset": offset}).fetchall()

        if not result:
            return []

        assets = [AssetDTO(**row._mapping) for row in result]
        return assets
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")
    


async def count_all_assets(session: Session) -> int:
    try:
        select_query = text("""SELECT COUNT(*) FROM asset""")
        result = session.execute(select_query)
        actual_value = result.first()[0] # type: ignore
        return actual_value # type: ignore
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")

async def get_all_assets_in_range(session: Session, start_id: int, end_id: int) -> Dict[str, int]:
    try:
        # Validate the range
        if start_id < 0 or end_id <= start_id:
            raise HTTPException(400, "Invalid range: start_id must be non-negative, and end_id must be greater than start_id.")

        # Define the query
        query = """
            SELECT id, ip
            FROM asset 
            WHERE id BETWEEN :start_id AND :end_id
        """
        
        # Execute the query
        result = session.execute(text(query), {"start_id": start_id, "end_id": end_id}).fetchall()

        if not result:
            return {}

        # Map results to a dictionary where keys are "ip" and values are "id"
        asset_map = {row._mapping["ip"]: row._mapping["id"] for row in result}
        return asset_map

    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")


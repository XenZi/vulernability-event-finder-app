from http.client import HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import text
from modules.user.models import User
from modules.user.schemas import UserCreate
from datetime import datetime
from shared.security import get_password_hash
from sqlalchemy.exc import SQLAlchemyError

def create_user(session: Session, user: UserCreate) -> User:
    """
    Inserts a new user record into the database and returns the created user object.
    
    This function uses raw SQL queries to perform the insertion and retrieve the last 
    inserted ID. It also includes error handling to ensure the database state remains 
    consistent in case of any issues.
    
    Args:
        session (sqlalchemy.orm.Session): The SQLAlchemy session object used for database operations.
        user (User): The user object containing the following attributes:
            - email (str): The email of the user.
            - password (str): The hashed password of the user.
            - isActive (bool): Indicates whether the user account is active.
            - creationDate (datetime): The date and time the user was created.
    
    Returns:
        User: The newly created User object with the following attributes:
            - id (int): The unique identifier of the user.
            - email (str): The email of the user.
            - password (str): The hashed password of the user.
            - isActive (bool): Indicates whether the user account is active.
            - creationDate (datetime): The date and time the user was created.
    
    Raises:
        HTTPException: If an error occurs during the database operation. Possible scenarios include:
            - Insertion fails (HTTP status 500 with a "Database error" message).
            - Unexpected errors (HTTP status 500 with an "Unexpected error" message).
    
    Example:
        >>> session = Session()
        >>> user = User(email="test@example.com", password="hashed_pw", isActive=True, creationDate=datetime.now())
        >>> new_user = create_user(session, user)
        >>> print(new_user.id, new_user.email)
    
    Notes:
        - Make sure to handle hashed passwords properly before calling this function.
        - Use `sessionmaker` to manage sessions and ensure proper session lifecycle management.
        - The function uses `SELECT LAST_INSERT_ID()` to retrieve the last inserted ID, 
          which is specific to MySQL. Ensure compatibility if switching to another database.
    """
    try:
        insert_query = text("""
            INSERT INTO user (email, password, isActive, creationDate) 
            VALUES (:email, :password, :isActive, :creationDate);
        """)
        
        session.execute(insert_query, {
            "email": user.email,
            "password": user.password,
            "isActive": user.isActive,
            "creationDate": user.creationDate
        })
        
        last_insert_id = session.execute(text("SELECT LAST_INSERT_ID()")).scalar()
        
        if not last_insert_id:  
            session.rollback()  
            raise HTTPException(500, "Error while inserting into the database")

        session.commit()

        return User(
            id=last_insert_id,
            email=user.email,
            password=user.password,
            isActive=user.isActive,
            creationDate=user.creationDate
        )
    except SQLAlchemyError as e:
        session.rollback()
        raise HTTPException(500, f"Database error: {str(e)}")
    except Exception as e:
        session.rollback()
        raise HTTPException(500, f"Unexpected error: {str(e)}")
    finally:
        session.close()

def get_user_by_email(session: Session, email: str) -> User | None:
    select_query = text("""SELECT * FROM user WHERE email=:email LIMIT 1""")
    result = session.execute(select_query, {"email": email}).first()
    return result

def get_user_by_id(session: Session, id: int) -> User | None:
    select_query = text("""SELECT * FROM user WHERE id=:id LIMIT 1""")
    result = session.execute(select_query, {"id": id}).first()
    return result

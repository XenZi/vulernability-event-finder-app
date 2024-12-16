from http.client import HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import text
from modules.user.user_schemas import User
from sqlalchemy.exc import SQLAlchemyError, IntegrityError
from shared.exceptions import DatabaseFailedOperation, DuplicateEntity

async def create_user(session: Session, user: User) -> User:
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
            - is_active (bool): Indicates whether the user account is active.
            - creation_date (datetime): The date and time the user was created.
    
    Returns:
        User: The newly created User object with the following attributes:
            - id (int): The unique identifier of the user.
            - email (str): The email of the user.
            - password (str): The hashed password of the user.
            - is_active (bool): Indicates whether the user account is active.
            - creation_date (datetime): The date and time the user was created.
    
    Raises:
        HTTPException: If an error occurs during the database operation. Possible scenarios include:
            - Insertion fails (HTTP status 500 with a "Database error" message).
            - Unexpected errors (HTTP status 500 with an "Unexpected error" message).
    """
    try:
        insert_query = text("""
            INSERT INTO user (email, password, is_active, creation_date) 
            VALUES (:email, :password, :is_active, :creation_date);
        """)
        
        session.execute(insert_query, {
            "email": user.email,
            "password": user.password,
            "is_active": user.is_active,
            "creation_date": user.creation_date
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
            is_active=user.is_active,
            creation_date=user.creation_date
        )
    except IntegrityError as e:
        session.rollback()
        if e.orig and e.orig.args[0] == 1062:
            raise DuplicateEntity(400, "Entity already exists")
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        session.rollback()
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")

async def get_user_by_email(session: Session, email: str) -> User | None:
    """
    Fetches a user record by email using raw SQL.

    Args:
        session (Session): The SQLAlchemy session object for database operations.
        email (str): The email of the user to fetch.

    Returns:
        User | None: The User object if found, or None if no user is found.

    Raises:
        HTTPException: If a database error occurs or an unexpected exception is raised.
    """
    try:
        select_query = text("""SELECT * FROM user WHERE email = :email LIMIT 1""")
        result = session.execute(select_query, {"email": email}).fetchone()
        if not result:
            return None
        result_dict = dict(result._mapping)
        return User(**result_dict)

    except SQLAlchemyError as e:
        raise HTTPException(500, f"Database error: {str(e)}")
    except Exception as e:
        raise HTTPException(500, f"Unexpected error: {str(e)}")
    
async def activate_user(session: Session, email: str):
    """
    Activates a user in the database by setting their 'is_active' status to True.

    This function executes an SQL UPDATE query to set the 'is_active' column of the 
    'user' table to True for the specified email address. If the operation is successful, 
    the changes are committed to the database. If any errors occur, an HTTPException 
    is raised with a relevant error message.

    Args:
        session (Session): The SQLAlchemy session object used to interact with the database.
        email (str): The email address of the user to be activated.

    Raises:
        HTTPException: If a database error or an unexpected error occurs during the execution.
            The error message will contain the details of the exception.
    """
    try:
        activate_query = text("""UPDATE user SET is_active = :is_active WHERE email = :email""")
        session.execute(activate_query, {"is_active": True, "email": email})
        session.commit()
    except SQLAlchemyError as e:
        raise HTTPException(500, f"Database error: {str(e)}")
    except Exception as e:
        raise HTTPException(500, f"Unexpected error: {str(e)}")

async def get_user_by_id(session: Session, id: int) -> User | None:
    try: 
        select_query = text("""SELECT * FROM user WHERE id=:id LIMIT 1""")
        result = session.execute(select_query, {"id": id}).first()
        if not result:
            return None
        result_dict = dict(result._mapping)
        return User(**result_dict)
    except SQLAlchemyError as e:
        raise HTTPException(500, f"Database error: {str(e)}")
    except Exception as e:
        raise HTTPException(500, f"Unexpected error: {str(e)}")


async def get_all_users(session: Session, page: int = 1, page_size: int = 10) -> list[User]:
    try:
        if page < 1 or page_size < 1:
            raise HTTPException(400, "Page and page size must be positive integers.")

        offset = (page - 1) * page_size
        select_query = text("""SELECT * FROM user LIMIT :limit OFFSET :offset""")
        result = session.execute(select_query, {"limit": page_size, "offset": offset}).fetchall()

        if not result:
            return []

        users = [User(**row._mapping) for row in result]
        return users
    except SQLAlchemyError as e:
        raise DatabaseFailedOperation(500, f"Database error: {str(e)}")
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error: {str(e)}")


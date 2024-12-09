from sqlalchemy.orm import Session
from sqlalchemy import text
from modules.user.models import User
from modules.user.schemas import UserCreate
from datetime import datetime
from shared.security import get_password_hash

def create_user(session: Session, user: UserCreate) -> User:
    user.password = get_password_hash(user.password)
    insert_query = text("""
            INSERT INTO user (email, password, isActive, creationDate) 
            VALUES (:email, :password, :isActive, :creationDate)
        """)
    result = session.execute(insert_query, {
            "email": user.email,
            "password": user.password,
            "isActive": user.isActive,
            "creationDate": user.creationDate
        })
    session.commit()
    
    result_user = get_user_by_id(session, result)
    print(result_user)

    if result_user:
        return User(
            id=result_user.id,
            email=result_user.email,
            password=result_user.password,
            isActive=result_user.isActive,
            creationDate=result_user.creationDate
        )
    return None

def get_user_by_email(session: Session, email: str) -> User | None:
    select_query = text("""SELECT * FROM user WHERE email=:email LIMIT 1""")
    result = session.execute(select_query, {"email": email}).first()
    return result

def get_user_by_id(session: Session, id: int) -> User | None:
    select_query = text("""SELECT * FROM user WHERE id=:id LIMIT 1""")
    result = session.execute(select_query, {"id": id}).first()
    return result

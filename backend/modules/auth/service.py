from modules.user.schemas import UserRegister, UserResponse, UserCreate
from modules.user.models import User
from sqlalchemy.orm import Session
from datetime import datetime
from modules.user import repository




def register_user(session: Session, user: UserRegister) -> UserResponse:
    user_db = UserCreate(
        email=user.email,
        password=user.password,
        isActive=False,
        creationDate=datetime.now()
    )
    result = repository.create_user(session, user_db)
    if result:
        return result_to_response(result)
    return None

def get_user_by_email(session: Session, email: str) -> UserResponse | None:
    result = repository.get_user_by_email(session, email)
    if result:
        return result_to_response(result)
    return None

def result_to_response(user: User) -> UserResponse:
    return UserResponse(
            id=user.id,
            email=user.email,
            password=user.password,
            isActive=user.isActive,
            creationDate=user.creationDate
        )
from modules.user.schemas import User, UserDTO, UserRegister
from sqlalchemy.orm import Session
from datetime import datetime
from modules.user import repository
from shared.exceptions import DuplicateEntity


def register_user(session: Session, user: UserRegister) -> UserDTO:
    doesUserExist: UserDTO | None = get_user_by_email(session, user.email)
    if doesUserExist:
        raise DuplicateEntity(400, "Email already taken")
    
    user_db = User(
        email=user.email,
        password=user.password,
        isActive=False,
        creationDate=datetime.now()
    )
    result = repository.create_user(session, user_db)
    return result_to_response(result)

def get_user_by_email(session: Session, email: str) -> UserDTO | None:
    result = repository.get_user_by_email(session, email)
    if result:
        return result_to_response(result)
    return None

def result_to_response(user: User) -> UserDTO:
    return UserDTO(
            id=user.id,
            email=user.email,
            isActive=user.isActive,
            creationDate=user.creationDate
        )
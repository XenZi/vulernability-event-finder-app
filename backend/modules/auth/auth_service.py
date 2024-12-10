from modules.user.user_schemas import User, UserDTO, UserRegister
from sqlalchemy.orm import Session
from datetime import datetime
from modules.user import user_repository
from shared.exceptions import DuplicateEntity
from modules.auth import auth_password_service as psw_service
from modules.user.user_mapper import user_to_DTO
from modules.user import user_service

def register_user(session: Session, user: UserRegister) -> UserDTO:
    doesUserExist: UserDTO | None = user_service.get_user_by_email(session, user.email)
    if doesUserExist:
        raise DuplicateEntity(400, "Email already taken")
    
    user_db = User(
        email=user.email,
        password=psw_service.get_password_hash(user.password),
        isActive=False,
        creationDate=datetime.now()
    )
    result = user_repository.create_user(session, user_db)
    return user_to_DTO(result)



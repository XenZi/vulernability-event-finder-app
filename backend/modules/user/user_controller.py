from fastapi import APIRouter
from sqlalchemy.orm import Session
from modules.user.user_schemas import UserDTO
from typing import Annotated
from modules.user import user_service
from fastapi import Depends
from modules.dependencies import get_db


router = APIRouter(prefix="/users")


@router.get("/", response_model=list[UserDTO])
def get_all_users(session: Annotated[Session, Depends(get_db)]) -> UserDTO:
    return user_service.get_all_users(session)

@router.get("/{email}/", response_model=UserDTO)
def get_user_by_email(session: Annotated[Session, Depends(get_db)], email: str) -> UserDTO:
    return user_service.get_user_by_email(session, email)

@router.get("/id/{id}", response_model=UserDTO)
def get_user_by_email(session: Annotated[Session, Depends(get_db)], id: int) -> UserDTO:
    return user_service.get_user_by_id(session, id)
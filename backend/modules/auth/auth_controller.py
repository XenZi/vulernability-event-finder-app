from fastapi import APIRouter
from sqlalchemy.orm import Session
from modules.user.user_schemas import UserDTO, UserRegister
from typing import Annotated
from modules.auth import auth_service as auth_service
from fastapi import Depends
from modules.dependencies import get_db
router = APIRouter()

@router.post("/register/", response_model=UserDTO)
def register(session: Annotated[Session, Depends(get_db)], user_in: UserRegister) -> UserDTO:
    return auth_service.register_user(session, user_in)

@router.get("/activate/{token}")
def activate_account(session: Annotated[Session, Depends(get_db)], token: str) -> UserDTO:
    return auth_service.activate_account(session, token)

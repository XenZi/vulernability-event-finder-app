from shared.response_schemas import SuccessfulTokenPayload
from modules.auth.schemas import UserLogin, Token
from fastapi import APIRouter, status
from sqlalchemy.orm import Session
from modules.user.user_schemas import UserDTO, UserRegister
from typing import Annotated
from modules.auth import auth_service as auth_service
from fastapi import Depends
from modules.dependencies import get_db
router = APIRouter()

@router.post("/register/", response_model=UserDTO, status_code=status.HTTP_201_CREATED)
def register(session: Annotated[Session, Depends(get_db)], user_in: UserRegister) -> UserDTO:
    return auth_service.register_user(session, user_in)

@router.get("/activate/{token}", status_code=status.HTTP_200_OK)
def activate_account(session: Annotated[Session, Depends(get_db)], token: str) -> UserDTO:
    return auth_service.activate_account(session, token)

@router.post("/login", response_model=SuccessfulTokenPayload, status_code=status.HTTP_200_OK)
def login(session: Annotated[Session, Depends(get_db)], login_data: UserLogin) -> SuccessfulTokenPayload:
    return auth_service.login(session, login_data)
from fastapi import APIRouter
from sqlalchemy.orm import Session
from modules.user.schemas import UserDTO, UserRegister
from typing import Annotated
from modules.auth import auth_service as auth_service
from fastapi import Depends
from modules.deps import get_db
router = APIRouter()

@router.post("/register/", response_model=UserDTO)
def register(session: Annotated[Session, Depends(get_db)], user_in: UserRegister) -> UserDTO:
    return auth_service.register_user(session, user_in)

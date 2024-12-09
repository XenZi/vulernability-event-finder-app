from fastapi import APIRouter, Depends, HTTPException
from modules.deps import SessionDep
from modules.user.schemas import UserRegister, UserResponse
from shared.exceptions import BaseHTTPException, ValidationFailed, EntityNotFound, DuplicateEntity
from typing import Any
from modules.auth import service as auth_service

router = APIRouter()

@router.post("/register/", response_model=UserResponse)
def register(session: SessionDep, user_in: UserRegister) -> Any:
    
    user = auth_service.get_user_by_email(session, user_in.email)
    if user:
        raise DuplicateEntity(400, "Email already taken")
    user = auth_service.register_user(session, user_in)
    return user

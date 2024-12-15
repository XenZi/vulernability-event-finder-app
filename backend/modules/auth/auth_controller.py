from shared.response_schemas import SuccessfulTokenPayload
from modules.auth.schemas import UserLogin, Token
from fastapi import APIRouter, status
from modules.user.user_schemas import UserDTO, UserRegister
from modules.auth import auth_service as auth_service
from shared.dependencies import SessionDep

router = APIRouter()

@router.post("/register/", response_model=UserDTO, status_code=status.HTTP_201_CREATED)
def register(session: SessionDep, user_in: UserRegister) -> UserDTO:
    return auth_service.register_user(session, user_in)

@router.get("/activate/{token}", status_code=status.HTTP_200_OK)
def activate_account(session: SessionDep, token: str) -> UserDTO:
    return auth_service.activate_account(session, token)

@router.post("/login", response_model=SuccessfulTokenPayload, status_code=status.HTTP_200_OK)
def login(session: SessionDep, login_data: UserLogin) -> SuccessfulTokenPayload:
    return auth_service.login(session, login_data)
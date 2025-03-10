from fastapi import Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from typing import Annotated
from modules.user import user_service
from shared.exceptions import AuthenticationFailedException, EntityNotFound
from modules.user.user_schemas import User, UserDTO
from modules.auth.jwt_service import decode_jwt
from modules.user.user_schemas import User
from sqlalchemy.orm import Session
from shared.database import engine
from collections.abc import Generator
from sqlalchemy.orm import Session

security = HTTPBearer()


def get_db() -> Generator[Session, None, None]:
    with Session(engine) as session:
        yield session


SessionDep = Annotated[Session, Depends(get_db)]

async def get_current_user(session: SessionDep, credentials: HTTPAuthorizationCredentials = Depends(security)) -> UserDTO:
    token = credentials.credentials
    try:
        token_data = decode_jwt(token=token)
        user = await user_service.get_user_by_id_as_dto(session, token_data.id)
        return user
    except AuthenticationFailedException as e:
        raise e
    except EntityNotFound as e:
        raise e

CurrentUser = Annotated[UserDTO, Depends(get_current_user)]


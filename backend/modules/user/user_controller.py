from fastapi import APIRouter, Query
from sqlalchemy.orm import Session
from modules.user.user_schemas import UserDTO
from typing import Annotated, List
from modules.user import user_service
from fastapi import Depends
from shared.dependencies import SessionDep, CurrentUser


router = APIRouter(prefix="/users")




@router.get("", response_model=UserDTO)
def get_user_by_id(user: CurrentUser) -> UserDTO:
    return user


# @router.get("", response_model=List[UserDTO])
# def get_users(
#     session: SessionDep,
#     page: int = Query(1, ge=1),
#     page_size: int = Query(10, ge=1)
# ) -> List[UserDTO]:
#     return user_service.get_users(session, page, page_size)
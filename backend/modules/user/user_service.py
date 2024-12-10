from modules.user.user_schemas import UserDTO
from sqlalchemy.orm import Session
from modules.user import user_repository
from modules.user import user_mapper as mapper
from shared.exceptions import EntityNotFound


    
def get_user_by_email(session: Session, email: str) -> UserDTO | None:
    result = user_repository.get_user_by_email(session, email)
    if not result:
        return result
    return mapper.user_to_DTO(result)

def get_user_by_id(session: Session, id: int) -> UserDTO:
    result = user_repository.get_user_by_id(session, id)
    if not result:
        raise EntityNotFound(404, "User not found")
    return mapper.user_to_DTO(result)

def get_all_users(session: Session) -> list[UserDTO]:
    result = user_repository.get_all_users(session)
    if result.count == 0:
        return result
    return mapper.userList_to_DTOList(result)

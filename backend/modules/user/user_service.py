from typing import List
from modules.user.user_schemas import User, UserDTO
from sqlalchemy.orm import Session
from modules.user import user_repository
from modules.user import user_mapper as mapper
from shared.exceptions import EntityNotFound


async def get_user_by_email_as_entity(session: Session, email: str) -> User:
    """
    Retrieve a user by email. Returns either a User object or UserDTO based on the 'dto' flag.

    :param session: Database session.
    :param email: The email of the user to retrieve.
    :param dto: Whether to return the result as a UserDTO.
    :return: User or UserDTO object.
    :raises EntityNotFound: If no user is found with the given ID.
    """
    user = await user_repository.get_user_by_email(session=session, email=email)
    if not user:
        raise EntityNotFound(404, "Not found")
    return user

async def get_user_by_email_as_dto(session: Session, email: str) -> UserDTO:
    """
    Retrieve a user by email. Returns either a User object or UserDTO based on the 'dto' flag.

    :param session: Database session.
    :param email: The email of the user to retrieve.
    :param dto: Whether to return the result as a UserDTO.
    :return: User or UserDTO object.
    :raises EntityNotFound: If no user is found with the given ID.
    """
    user = await user_repository.get_user_by_email(session=session, email=email)
    if not user:
        raise EntityNotFound(404, "Not found")
    return mapper.user_to_DTO(user=user)


async def get_user_by_id_as_entity(session: Session, id: int) -> User:
    """
    Retrieve a user by ID. Returns either a User object or UserDTO based on the 'dto' flag.

    :param session: Database session.
    :param id: The ID of the user to retrieve.
    :param dto: Whether to return the result as a UserDTO.
    :return: User or UserDTO object.
    :raises EntityNotFound: If no user is found with the given ID.
    """
    user = await user_repository.get_user_by_id(session, id)
    if not user:
        raise EntityNotFound(404, "User not found")
    return user

async def get_user_by_id_as_dto(session: Session, id: int) -> UserDTO:
    """
    Retrieve a user by ID. Returns either a User object or UserDTO based on the 'dto' flag.

    :param session: Database session.
    :param id: The ID of the user to retrieve.
    :param dto: Whether to return the result as a UserDTO.
    :return: User or UserDTO object.
    :raises EntityNotFound: If no user is found with the given ID.
    """
    user = await user_repository.get_user_by_id(session, id)
    if not user:
        raise EntityNotFound(404, "User not found")
    return mapper.user_to_DTO(user)

async def get_users(session: Session, page: int, page_size: int) -> List[UserDTO]:
    """
    Retrieve a paginated list of users from the database and map them to UserDTO objects.

    Args:
        session (Session): The database session used to query the users.
        page (int): The page number to retrieve.
        page_size (int): The number of users per page.

    Returns:
        List[UserDTO]: A list of user data transfer objects (DTOs). If no users are found, returns an empty list.

    Raises:
        Any exceptions raised by the user repository or mapper functions are propagated.
    """
    users = await user_repository.get_all_users(session, page, page_size)
    if not users:
        return []
    return mapper.userList_to_DTOList(users)

async def update_fcm(session: Session, token: str, user_email: str):
    await user_repository.update_fcm(session, token, user_email)

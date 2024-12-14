from sqlalchemy import true
from shared.response_schemas import SuccessfulTokenPayload
from modules.auth import jwt_service
from modules.auth.schemas import UserLogin
from modules.user.user_schemas import User, UserDTO, UserRegister
from sqlalchemy.orm import Session
from datetime import datetime
from modules.user import user_repository
from shared.exceptions import AuthenticationFailedException, DuplicateEntity, InvalidToken, EntityNotFound
from modules.auth import password_service
from modules.user.user_mapper import user_to_DTO
from modules.user import user_service
from shared.token import serializer, SALT
from modules.mail.mail_service import send_activation_token
from config.logger_config import logger

def register_user(session: Session, user: UserRegister) -> UserDTO:
    """
    Registers a new user in the system by validating the provided details and saving them to the database.

    This function checks if the email provided by the user already exists in the system.
    If the email is already taken, a `DuplicateEntity` exception is raised with an appropriate error message.
    If the email is unique, the user's data is hashed, a new user record is created, and the user is saved to the database.
    Additionally, an activation token is sent to the user to enable account activation.

    Args:
        session (Session): The SQLAlchemy session object used to interact with the database.
        user (UserRegister): A user registration model that contains the user's input details, 
                              such as email and password.

    Returns:
        UserDTO: A Data Transfer Object (DTO) representing the user, containing user details such as email 
                 and activation status.

    Raises:
        DuplicateEntity: If the email address is already registered in the system (HTTP status 400).
    """

    doesUserExist: UserDTO | None = user_service.get_user_by_email_as_dto(session, user.email)
    logger.info(f'Checking if user with the {user.email} exists')
    if doesUserExist:
        raise DuplicateEntity(400, "Email already taken")
    
    user_db = User(
        email=user.email,
        password=password_service.get_password_hash(user.password),
        is_active=False,
        creation_date=datetime.now()
    )
    print(user_db.password)
    result = user_repository.create_user(session, user_db)
    send_activation_token(user)
    return user_to_DTO(result)

def login(session: Session, login_data: UserLogin) -> SuccessfulTokenPayload:
    """
    Authenticates a user and generates a JWT token upon successful login.

    Args:
        session (Session): The database session used to query user information.
        login_data (UserLogin): The login data provided by the user, including email and password.

    Returns:
        str: A JWT token encapsulated in a `SuccessfulTokenPayload` object.

    Raises:
        AuthenticationFailedException: Raised if the user credentials are invalid.
    """
    user = user_service.get_user_by_email_as_entity(session, login_data.email)
    if not user:
        raise EntityNotFound(400, 'Not found')
    if not user.is_active:
        raise AuthenticationFailedException(401, 'User account is not validated yet.')
    valid_credentials = password_service.compare_password(login_data.password, user.password)
    if not valid_credentials:
        raise AuthenticationFailedException(401, "Authentication failed. Invalid username or password")
    token = jwt_service.generate_jwt({"id":user.id, "email": user.email})
    return SuccessfulTokenPayload(token=token)

def activate_account(session: Session, token: str) -> UserDTO:
    """
    Activates a user's account by verifying the provided activation token.

    This function attempts to decode the provided activation token to retrieve the user's email. 
    The token is expected to be valid for 15 minutes (900 seconds). If the token is valid, 
    the user's email is used to look up the user in the database. If the user exists, their account is 
    activated, setting the `is_active` field to `True`. If the token is invalid or expired, or the user 
    cannot be found, an appropriate exception is raised.

    Args:
        session (Session): The SQLAlchemy session object used to interact with the database.
        token (str): The activation token sent to the user, which contains the user's email.

    Returns:
        UserDTO: A Data Transfer Object (DTO) representing the user with their updated activation status.

    Raises:
        EntityNotFound: If no user with the decoded email is found in the database (HTTP status 404).
        InvalidToken: If the token is invalid, expired, or cannot be decoded (HTTP status 400).
    """
    try:
        email = serializer.loads(token, salt=SALT, max_age=900)
        doesUserExist: UserDTO | None = user_service.get_user_by_email_as_dto(session, email)
        if not doesUserExist:
            raise EntityNotFound(404, "User not found")
        user_repository.activate_user(session, email)
        doesUserExist.is_active = True
        return doesUserExist
    except EntityNotFound:
        raise
    except Exception as e:
        raise InvalidToken(400, "Invalid or expired token") from e

    





from modules.user.user_schemas import User, UserDTO, UserRegister
from sqlalchemy.orm import Session
from datetime import datetime
from modules.user import user_repository
from shared.exceptions import DuplicateEntity, InvalidToken, EntityNotFound
from modules.auth import auth_password_service as psw_service
from modules.user.user_mapper import user_to_DTO
from modules.user import user_service
from shared.token import serializer, SALT
from modules.mail.mail_service import send_activation_token


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

    Example:
        To register a new user with email "user@example.com" and password "securepassword":
        
        new_user = UserRegister(email="user@example.com", password="securepassword")
        user_dto = register_user(session, new_user)

    Notes:
        - The user's password is hashed using a password hashing service before storing it in the database.
        - The `send_activation_token` function is called to send an activation email to the user.
        - The user is initially set as inactive (`isActive=False`).
        - This function assumes the existence of `user_service`, `user_repository`, `psw_service`, and other dependencies.
    """
    doesUserExist: UserDTO | None = user_service.get_user_by_email(session, user.email)
    if doesUserExist:
        raise DuplicateEntity(400, "Email already taken")
    
    user_db = User(
        email=user.email,
        password=psw_service.get_password_hash(user.password),
        isActive=False,
        creationDate=datetime.now()
    )
    result = user_repository.create_user(session, user_db)
    print(result)
    send_activation_token(user)
    return user_to_DTO(result)


def activate_account(session: Session, token: str) -> UserDTO:
    """
    Activates a user's account by verifying the provided activation token.

    This function attempts to decode the provided activation token to retrieve the user's email. 
    The token is expected to be valid for 15 minutes (900 seconds). If the token is valid, 
    the user's email is used to look up the user in the database. If the user exists, their account is 
    activated, setting the `isActive` field to `True`. If the token is invalid or expired, or the user 
    cannot be found, an appropriate exception is raised.

    Args:
        session (Session): The SQLAlchemy session object used to interact with the database.
        token (str): The activation token sent to the user, which contains the user's email.

    Returns:
        UserDTO: A Data Transfer Object (DTO) representing the user with their updated activation status.

    Raises:
        EntityNotFound: If no user with the decoded email is found in the database (HTTP status 404).
        InvalidToken: If the token is invalid, expired, or cannot be decoded (HTTP status 400).

    Example:
        To activate a user's account with an activation token:
        
        token = "some-valid-activation-token"
        user_dto = activate_account(session, token)

    Notes:
        - The activation token is serialized using a salt value (`SALT`), and expires after 15 minutes (900 seconds).
        - This function assumes the existence of `user_service`, `user_repository`, and the `serializer` object for decoding the token.
        - The token is expected to contain the user's email address, and the `user_repository.activate_user` function is used to update the user's status in the database.
    """
    try:
        email = serializer.loads(token, salt=SALT, max_age=900)
        doesUserExist: UserDTO | None = user_service.get_user_by_email(session, email)
        if not doesUserExist:
            raise EntityNotFound(404, "User not found")
        user_repository.activate_user(session, email)
        doesUserExist.isActive = True
        return doesUserExist
    except Exception as e:
        raise InvalidToken(400, "Invalid or expired token")
    





import jwt
from datetime import datetime, timedelta, timezone
from typing import Any, Dict
from fastapi import status
from pydantic import ValidationError
from modules.auth.schemas import TokenData
from config.config import settings
from modules.auth.schemas import TokenData
from shared.exceptions import AuthenticationFailedException

def generate_jwt(
    payload: Dict[str, Any],
) -> str:
    """
    Generate a JSON Web Token (JWT).

    Args:
        payload (Dict[str, Any]): The payload data to encode into the JWT.
        secret (str): The secret key used to sign the JWT.
        algorithm (str, optional): The algorithm used for signing. Defaults to "HS256".
        expiration_minutes (Optional[int], optional): Token expiration time in minutes. Defaults to 60.

    Returns:
        str: The generated JWT as a string.
    """
    payload["exp"] = datetime.now(timezone.utc) + timedelta(days=14)

    token = jwt.encode(payload, settings.secret_key, algorithm=settings.password_algorithm)
    
    if isinstance(token, bytes): 
        token = token.decode("utf-8")

    return token

def decode_jwt(token: str) -> TokenData:
    try:
        payload = jwt.decode(token, settings.secret_key, algorithms=settings.password_algorithm)
        token_data: TokenData = TokenData(**payload)
        return token_data
    except (jwt.InvalidTokenError, ValidationError):
        raise AuthenticationFailedException(status_code=status.HTTP_403_FORBIDDEN, detail="Could not validate credentials")

from passlib.context import CryptContext


pwd_context = CryptContext(schemes=["bcrypt"], bcrypt__rounds=10)

def get_password_hash(password: str) -> str:
    """
    Hashes a plaintext password using a secure hashing algorithm.

    Args:
        password (str): The plaintext password to be hashed.

    Returns:
        str: The hashed version of the provided password.
    """
    return pwd_context.hash(password)

def compare_password(plain_password: str, hashed_password: str) -> bool:
    """
    Verifies a plaintext password against a hashed password.

    Args:
        plain_password (str): The plaintext password provided for verification.
        hashed_password (str): The hashed password to verify against.

    Returns:
        bool: True if the plaintext password matches the hashed password, False otherwise.
    """
    return pwd_context.verify(plain_password, hashed_password)
    
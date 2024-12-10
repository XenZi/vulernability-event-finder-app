

def get_password_hash(password: str) -> str:
    return password+"HASHED"

def compare_password(input, password: str) -> bool:
    return get_password_hash(input) == password
    
from pydantic import BaseModel
from datetime import datetime



class UserRegister(BaseModel):
    email: str
    password: str

class User(BaseModel): 
    id: int | None = None
    email: str
    password: str
    is_active: bool
    creation_date: datetime

class UserDTO(BaseModel):
    id: int
    email: str
    is_active: bool
    creation_date: datetime


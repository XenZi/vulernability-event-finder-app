from pydantic import BaseModel
from datetime import datetime



class User(BaseModel): # kreirani user punih informacija
    id: int = None
    email: str
    password: str
    isActive: bool
    creationDate: datetime

class UserDTO(BaseModel):
    id: int
    email: str
    isActive: bool
    creationDate: datetime

class UserRegister(BaseModel):
    email: str
    password: str

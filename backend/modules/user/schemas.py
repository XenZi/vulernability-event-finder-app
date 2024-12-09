from pydantic import BaseModel, validator
from datetime import datetime

class UserBase(BaseModel):
    email: str
    isActive: bool = False
    creationDate: datetime = None


class UserCreate(UserBase):
    password: str

class UserRegister(BaseModel):
    email: str
    password: str


class UserResponse(UserBase):
    id: int
    password: str


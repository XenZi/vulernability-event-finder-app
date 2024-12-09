from pydantic import BaseModel
from datetime import datetime

class UserCreate(BaseModel):
    email: str
    password: str
    isActive: bool = True
    creationDate: datetime = None

class UserResponse(UserCreate):
    id: int

from modules.user.user_schemas import UserDTO
from shared.enums import PriorityLevel
from pydantic import BaseModel
from datetime import datetime, timezone


class AssetRegister(BaseModel):
    ip: str

class Asset(BaseModel):
    id: int 
    ip: str
    notification_priority_level: PriorityLevel = PriorityLevel.Low
    creation_date: datetime = datetime.now(timezone.utc)
    user: UserDTO

class AssetDTO(BaseModel):
    id: int 
    ip: str
    notification_priority_level: PriorityLevel = PriorityLevel.Low
    creation_date: datetime = datetime.now(timezone.utc)
    user_id: int

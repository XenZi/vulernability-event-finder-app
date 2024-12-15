from modules.user.user_schemas import User
from shared.enums import PriorityLevel
from pydantic import BaseModel
from datetime import datetime, timezone


class AssetRegister(BaseModel):
    ip: str

class Asset(BaseModel):
    id: int | None = None
    ip: str
    notification_priority_level: PriorityLevel = PriorityLevel.Minor
    creation_date: datetime = datetime.now(timezone.utc)
    user: User | None = None

class AssetDTO(BaseModel):
    id: int | None = None
    ip: str
    notification_priority_level: PriorityLevel = PriorityLevel.Minor
    creation_date: datetime = datetime.now(timezone.utc)
    # user_id: int

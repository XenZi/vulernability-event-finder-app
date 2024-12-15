from backend.modules.user.user_schemas import User
from shared.enums import PriorityLevel
from pydantic import BaseModel
from datetime import datetime, timezone


class Asset(BaseModel):
    id: int | None = None
    ip: str
    notification_priority_level: PriorityLevel = PriorityLevel.NoPriority
    creation_date: datetime = datetime.now(timezone.utc)
    user: User | None = None

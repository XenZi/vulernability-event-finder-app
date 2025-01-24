from pydantic import BaseModel
from datetime import datetime, timezone



class Notification(BaseModel):
    id: int
    user_id: int
    asset_id: int
    asset_ip: str
    seen: bool
    description: str
    creation_date: datetime = datetime.now(timezone.utc)

class NotificationUpdateDTO(BaseModel):
    id: int
    user_id: int

class NotificationData(BaseModel):
    user_id: int
    asset_id: int
    asset_ip: str
    event_count: int

    
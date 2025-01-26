from pydantic import BaseModel
from datetime import datetime, timezone



class NotificationInfo(BaseModel):
    id: int
    user_id: int
    fcm_token: str
    asset_id: int
    asset_ip: str
    seen: bool
    event_count: int
    creation_date: datetime = datetime.now(timezone.utc)

class NotificationUpdateDTO(BaseModel):
    id: int
    user_id: int

class NotificationData(BaseModel):
    user_id: int
    fcm_token: str
    asset_id: int
    asset_ip: str
    event_count: int

    
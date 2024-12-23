from pydantic import BaseModel

from shared.enums import EventStatus, PriorityLevel
from datetime import datetime

class Event(BaseModel):
    id: int
    uuid: str
    status: EventStatus
    host: str
    port: str
    priority: PriorityLevel
    location: str
    creation_date: datetime
    last_occurance: datetime
    asset_id: int


class ReceivedEvent(BaseModel):
    timestamp: str
    event_uuid: str
    ip: str
    port: int
    category_name: str
    urgency: str

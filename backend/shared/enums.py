from enum import Enum

class PriorityLevel(Enum):
    high = 3
    medium = 2
    low = 1
    noPriority = 0

class EventStatus(Enum):
    FalsePositive = 3
    Removed = 2
    Acknowledged = 1
    Discovered = 0
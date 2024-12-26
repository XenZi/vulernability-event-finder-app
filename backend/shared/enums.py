from enum import Enum

class PriorityLevel(Enum):
    high = 3
    medium = 2
    low = 1
    noPriority = 0

class EventStatus(Enum):
    Discovered = 0
    Acknowledged = 1
    Removed = 2
    FalsePositive = 3
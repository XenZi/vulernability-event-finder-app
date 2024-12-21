from enum import Enum

class PriorityLevel(Enum):
    High = 3
    Medium = 2
    Low = 1
    NoPriority = 0

class EventStatus(Enum):
    Discovered = 0
    Acknowledged = 1
    Removed = 2
    FalsePositive = 3
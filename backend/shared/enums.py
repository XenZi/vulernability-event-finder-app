from enum import Enum

class PriorityLevel(Enum):
    Critical = 3
    Major = 2
    Minor = 1
    NoPriority = 0

class EventStatus(Enum):
    Discovered = 0
    Acknowledged = 1
    Removed = 2
    FalsePositive = 3
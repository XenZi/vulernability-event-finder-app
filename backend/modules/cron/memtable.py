from typing import TypedDict
from datetime import datetime
from typing import Dict


class Entry(TypedDict):
    timestamp: datetime
    data: str
    expected_rows: int



DictionaryType = Dict[str, Entry]

memtable_dict: DictionaryType = {}

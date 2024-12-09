from shared.database import engine
from collections.abc import Generator
from sqlalchemy.orm import Session
from typing import Annotated
from fastapi import Depends




def get_db() -> Generator[Session, None, None]:
    with Session(engine) as session:
        yield session

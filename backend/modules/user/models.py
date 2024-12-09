from sqlalchemy import Column, Integer, String, Boolean, DateTime
from sqlalchemy.sql import func
from shared.database import Base

class User(Base):
    __tablename__ = "user"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, index=True)
    password = Column(String(255))
    isActive = Column(Boolean, default=False)
    creationDate = Column(DateTime, server_default=func.now())

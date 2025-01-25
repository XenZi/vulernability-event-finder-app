from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from config.config import settings

DATABASE_URL = settings.database_uri

engine = create_engine(
    DATABASE_URL,
    pool_size=5,           # Minimum number of connections in the pool
    max_overflow=0,        # No additional connections beyond the pool size
    pool_pre_ping=True,    # Ensures connections are alive before using them
    pool_timeout=30        # Max time to wait for a connection
)
    

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


# Base class for models
Base = declarative_base()
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from config.config import settings

# Example connection string
DATABASE_URL = settings.database_uri
# Create SQLAlchemy engine
engine = create_engine(DATABASE_URL)
    

# Create session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base class for models
Base = declarative_base()
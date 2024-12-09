from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker


# Example connection string
DATABASE_URL = 'mysql://root:root@localhost:3306/vulnerability_finder'
# Create SQLAlchemy engine
engine = create_engine(DATABASE_URL)
    

# Create session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base class for models
Base = declarative_base()
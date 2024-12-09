from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker


# Example connection string
DATABASE_URL = 'mysql://root:root@localhost:3306/vulnerability_finder'
# Create SQLAlchemy engine
engine = create_engine(DATABASE_URL)

try:
    # Use your MySQL credentials here
    engine = create_engine('mysql://root:root@localhost:3306/vulnerability_finder')
    connection = engine.connect()
    print("Connection successful!")
    connection.close()
except Exception as e:
    print(f"Connection error: {e}")




    
# Create a sessionmaker to manage sessions
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base class for models
Base = declarative_base()

from sqlalchemy.orm import Session
from sqlalchemy import text
from user.models import User
from user.schemas import UserCreate

class UserRepository:
    def __init__(self, db: Session):
        self.db = db

    def get_user_by_email(self, email: str):
        return self.db.query(User).filter(User.email == email).first()

    def create_user(self, user: UserCreate):

        db_user = User(email=user.email, password=user.password, isActive=False)
        self.db.add(db_user)
        self.db.commit()
        self.db.refresh(db_user)
        return db_user

    def get_all_users(self):
        return self.db.query(User).all()

    def activate_user(self, user_id: int):
        user = self.db.query(User).filter(User.id == user_id).first()
        if user:
            user.isActive = True
            self.db.commit()
            return user
        return None

    def get_user_by_email(self, email: str):
        query = text("SELECT * FROM user WHERE email = :email")
        result = self.db.execute(query, {"email": email}).fetchone()
        print(123)
        if result:
            return User(id=result[0], email=result[1], password=result[2], isActive=result[3], creationDate=result[4])
        return None

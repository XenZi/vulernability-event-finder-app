from fastapi import FastAPI, Request, Depends
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import List
from sqlalchemy.orm import Session
from shared.database import SessionLocal, engine
from user.repository import UserRepository
from user.schemas import UserCreate, UserResponse
from shared.exceptions import ApiError, BaseHTTPException, ValidationFailed, DuplicateEntity, EntityNotFound


app = FastAPI()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close() 

def get_user_repository(db: Session):
    return UserRepository(db)


@app.exception_handler(BaseHTTPException)
async def handle_all_exceptions(request: Request, exc: BaseHTTPException):
    return JSONResponse(
        content=ApiError(message=exc.detail, status_code=exc.status_code, path=request.url.path).model_dump(),
        status_code=exc.status_code,
    )



@app.get("/")
async def root():
    return {"message": "Hello Worlds"}


# Register user route
@app.post("/register/", response_model=UserResponse)
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    user_repo = get_user_repository(db)
    if user_repo.get_user_by_email(user.email):
        raise DuplicateEntity(400, "Email already taken")
    new_user = user_repo.create_user(user)
    return new_user

# Get all users
@app.get("/users/", response_model=list[UserResponse])
def get_users(db: Session = Depends(get_db)):
    user_repo = get_user_repository(db)
    return user_repo.get_all_users()

# Deactivate a user
@app.patch("/activate/{user_id}", response_model=UserResponse)
def deactivate_user(user_id: int, db: Session = Depends(get_db)):
    user_repo = get_user_repository(db)
    user = user_repo.deactivate_user(user_id)
    if not user:
        raise EntityNotFound(404, "User not found")
    return user

@app.get("/users/{email}", response_model=UserResponse)
def find_user_by_email(email: str, db: Session = Depends(get_db)):
    user_repo = get_user_repository(db)
    user = user_repo.get_user_by_email(email)
    if not user:
        raise EntityNotFound(404, "User not found")
    return user





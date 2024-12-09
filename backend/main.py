from fastapi import FastAPI, Request, Depends
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import List
from sqlalchemy.orm import Session
from shared.database import SessionLocal, engine
from modules.user.schemas import UserCreate, UserResponse
from shared.exceptions import ApiError, BaseHTTPException
from modules.router import api_router
from fastapi.middleware.cors import CORSMiddleware



app = FastAPI()

app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

app.include_router(api_router)



@app.exception_handler(BaseHTTPException)
async def handle_all_exceptions(request: Request, exc: BaseHTTPException):
    return JSONResponse(
        content=ApiError(message=exc.detail, status_code=exc.status_code, path=request.url.path).model_dump(),
        status_code=exc.status_code,
    )



@app.get("/")
async def root():
    return {"message": "Hello Worlds"}


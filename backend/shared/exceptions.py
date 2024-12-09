import datetime
from typing import Callable
from fastapi import HTTPException, Request
from fastapi.responses import JSONResponse
from pydantic import BaseModel

class ApiError(BaseModel):
    message: str
    status_code: int
    path: str 
    time: str = str(datetime.datetime.now())

    
class BaseHTTPException(HTTPException):
    def __init__(self, status_code, detail = None, headers = None):
        super().__init__(status_code, detail, headers)


class ValidationFailed(BaseHTTPException):
    def __init__(self, status_code, detail=None, headers=None):
        super().__init__(status_code, detail, headers)

class EntityNotFound(BaseHTTPException):
    def __init__(self, status_code, detail=None, headers=None):
        super().__init__(status_code, detail, headers)

class DuplicateEntity(BaseHTTPException):
    def __init__(self, status_code, detail=None, headers=None):
        super().__init__(status_code, detail, headers)


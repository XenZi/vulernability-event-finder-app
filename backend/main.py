from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from shared.exceptions import ApiError, BaseHTTPException, ValidationFailed


app = FastAPI()

@app.exception_handler(BaseHTTPException)
async def handle_all_exceptions(request: Request, exc: BaseHTTPException):
    return JSONResponse(
        content=ApiError(message=exc.detail, status_code=exc.status_code, path=request.url.path).model_dump(),
        status_code=exc.status_code,
    )

@app.get("/")
async def root():
    return {"message": "Hello World"}

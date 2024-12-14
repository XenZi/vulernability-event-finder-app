from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from shared.exceptions import ApiError, BaseHTTPException
from modules.router import api_router
from fastapi.middleware.cors import CORSMiddleware
from shared.middlewares import LoggingMiddleware


app = FastAPI()

app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

app.include_router(api_router)
app.add_middleware(LoggingMiddleware)


@app.exception_handler(BaseHTTPException)
async def handle_all_exceptions(request: Request, exc: BaseHTTPException):
    return JSONResponse(
        content=ApiError(message=exc.detail, status_code=exc.status_code, path=request.url.path).model_dump(),
        status_code=exc.status_code,
    )



@app.get("/")
async def root():
    return {"message": "Hello Worlds"}


from fastapi import APIRouter
from modules.auth.auth_controller import router as auth_router
from modules.user.user_controller import router as user_router
from modules.assets.asset_controller import router as asset_router


api_router = APIRouter()
api_router.include_router(auth_router)
api_router.include_router(user_router)
api_router.include_router(asset_router)
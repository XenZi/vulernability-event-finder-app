from fastapi import APIRouter, Query, status
from modules.assets.asset_schemas import AssetDTO, AssetRegister, Asset
from shared.dependencies import SessionDep, CurrentUser
from modules.assets import asset_service

router = APIRouter(prefix="/assets")

@router.post("/", response_model=AssetDTO, status_code=status.HTTP_201_CREATED)
async def create_asset(session: SessionDep, current_user: CurrentUser, asset: AssetRegister) -> AssetDTO:
    return asset_service.create_asset(session=session, user=current_user, asset=asset)

@router.get("/{asset_id}", response_model=AssetDTO, status_code=status.HTTP_200_OK)
async def get_asset_by_id(session: SessionDep, current_user: CurrentUser, asset_id: int) -> AssetDTO:
    return asset_service.get_asset_by_id_as_dto(session=session, asset_id=asset_id, user_id=current_user.id)

@router.delete("/{asset_id}", status_code=status.HTTP_200_OK)
async def get_asset_by_id(session: SessionDep, current_user: CurrentUser, asset_id: int):
    asset_service.delete_asset(session=session, asset_id=asset_id, user_id=current_user.id)
    return status.HTTP_200_OK

@router.put("/update", response_model=AssetDTO, status_code=status.HTTP_200_OK)
async def get_asset_by_id(session: SessionDep, current_user: CurrentUser, asset: Asset) -> AssetDTO:
    return asset_service.update_asset_notification_priority_level(session=session, asset=asset, user=current_user)

@router.get("/user_assets/", response_model=list[AssetDTO], status_code=status.HTTP_200_OK)
async def get_all_assets(
    session: SessionDep,
    current_user: CurrentUser,
    page: int = Query(1, ge=1),
    page_size: int = Query(10, ge=1)
) -> list[AssetDTO]:
    return asset_service.get_all_assets_for_user(session, current_user.id, page, page_size)

@router.get("/", response_model=list[AssetDTO], status_code=status.HTTP_200_OK)
async def get_all_assets(
    session: SessionDep,
    page: int = Query(1, ge=1),
    page_size: int = Query(10, ge=1)
) -> list[AssetDTO]:
    return asset_service.get_all_assets(session, page, page_size)
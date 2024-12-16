from typing import List
from modules.assets import asset_mapper
from modules.assets.asset_schemas import Asset, AssetDTO, AssetRegister
from sqlalchemy.orm import Session
from modules.assets import asset_repository
from modules.user import user_mapper
from shared.exceptions import AuthenticationFailedException, EntityNotFound, DuplicateEntity, DatabaseFailedOperation, Unauthorized
from modules.user.user_schemas import UserDTO
from shared.enums import PriorityLevel
from datetime import datetime
from modules.assets.asset_mapper import asset_to_DTO, assetList_to_DTOList

def create_asset(session: Session, user: UserDTO, asset: AssetRegister) -> AssetDTO:
    asset_db = Asset(
        id=0,
        ip=asset.ip,
        notification_priority_level=PriorityLevel.Minor,
        creation_date=datetime.now(),
        user=user
    )
    try:
        result = asset_repository.create_asset(session, asset_db)
    except DuplicateEntity as e:
        raise e  
    except Exception as e:
        raise DatabaseFailedOperation(500, f"Unexpected error during asset creation: {str(e)}")
    return result

def get_asset_by_id_as_dto(session: Session, asset_id:int, user_id: int) -> AssetDTO:
    asset = asset_repository.get_asset_by_id(session=session, asset_id=asset_id, user_id=user_id)
    if not asset:
        raise EntityNotFound(404, "Asset not found")
    if asset.user_id != user_id:
        raise AuthenticationFailedException(401, 'Unathorized')
    return asset

def get_all_assets_for_user(session: Session, user_id: int, page: int, page_size: int) -> List[AssetDTO]:
    assets = asset_repository.get_all_assets_for_user(session=session, user_id=user_id, page=page, page_size=page_size)
    if not assets:
        return []
    return assets

def update_asset_notification_priority_level(session: Session, assetDTO: AssetDTO, user: UserDTO) -> AssetDTO:
    if assetDTO.user_id != user.id:
        raise Unauthorized(401, 'Unauthorized')
    asset = asset_mapper.asssetDTO_to_asset(assetDTO, user)
    asset.user = user
    result = asset_repository.update_notification_priority_level(session=session, asset=assetDTO)
    return result

def delete_asset(session: Session, asset_id: int, user_id: int) -> AssetDTO:
    loaded_asset = asset_repository.get_asset_by_id(session, asset_id, user_id)
    if loaded_asset is None:
        raise EntityNotFound(404, "Entity not found")
    if loaded_asset.user_id != user_id: # type: ignore
        raise Unauthorized(401, 'Unathorized')
    asset_repository.delete_asset(session=session, asset_id=asset_id, user_id=user_id)
    return loaded_asset

def get_all_assets(session: Session, page: int, page_size: int) -> List[AssetDTO]:
    assets = asset_repository.get_all_assets(session=session, page=page, page_size=page_size)
    if not assets:
        return []
    return assets
from typing import List
from modules.assets.asset_schemas import Asset, AssetDTO
from modules.user.user_schemas import User, UserDTO

def asset_to_DTO(asset: Asset) -> AssetDTO:
    return AssetDTO(
        id=asset.id or 0,
        ip=asset.ip,
        notification_priority_level=asset.notification_priority_level,
        creation_date=asset.creation_date,
        user_id=asset.user.id if asset.user else 0
    )

def assetList_to_DTOList(assets: list[Asset]) -> List[AssetDTO]:
    result: List[AssetDTO] = []
    for a in assets:
        result.append(asset_to_DTO(a))
    return result

def asssetDTO_to_asset(assetDTO: AssetDTO, user: UserDTO) -> Asset:
    return Asset(
        id=assetDTO.id,
        ip=assetDTO.ip,
        notification_priority_level=assetDTO.notification_priority_level,
        creation_date=assetDTO.creation_date,
        user=user
    )
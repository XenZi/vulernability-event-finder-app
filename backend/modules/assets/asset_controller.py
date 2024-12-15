from datetime import timezone, datetime
from fastapi import APIRouter, Depends, status
from shared.enums import PriorityLevel
from modules.assets.asset_schemas import AssetDTO
from shared.dependencies import SessionDep, CurrentUser

router = APIRouter(prefix="/assets")



@router.post("/", response_model=AssetDTO, status_code=status.HTTP_201_CREATED)
async def create_asset(session: SessionDep, current_user: CurrentUser) -> AssetDTO:
    return AssetDTO(
        id=0,
        notification_priority_level=PriorityLevel.Critical,
        creation_date=datetime.now(timezone.utc),
        ip="213123312"
    )

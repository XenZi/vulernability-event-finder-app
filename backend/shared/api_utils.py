import httpx
from config.config import settings

async def send_get_request_to_api(ip_list: list[str], date_from: str = "") -> dict:
    headers = {"Authorization": f"Bearer {settings.external_jwt_token}"}
    base_url = f'{settings.external_base_url_events}'
    if date_from != "":
        base_url += f"time_from={date_from}"
    base_url += f'?ip={",".join(ip_list)}'
    print(base_url)
    async with httpx.AsyncClient() as client:
        response = await client.get(base_url, headers=headers)
        response.raise_for_status()
        return response.json()
    
async def send_get_request_for_single(uuid: str) -> dict:
    headers = {"Authorization": f"Bearer {settings.external_jwt_token}"}
    base_url = f'{settings.external_base_url_event}'
    base_url += f'/{uuid}'
    async with httpx.AsyncClient() as client:
        response = await client.get(base_url,headers=headers)
        response.raise_for_status()
        return response.json()
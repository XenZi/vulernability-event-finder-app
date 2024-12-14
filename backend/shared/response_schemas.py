from pydantic import BaseModel


class SuccessfulTokenPayload(BaseModel):
    token: str
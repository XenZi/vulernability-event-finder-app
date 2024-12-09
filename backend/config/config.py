from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):

    # Pydantic Settings configuration part
    model_config = SettingsConfigDict(
        env_file=".env",
        env_ignore_empty=True,
        extra="ignore",
    )

    database_uri: str

settings = Settings()  # type: ignore

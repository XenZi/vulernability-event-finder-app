from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):

    # Pydantic Settings configuration part
    model_config = SettingsConfigDict(
        env_file=".env",
        env_ignore_empty=True,
        extra="ignore",
    )

    database_uri: str
    secret_key: str
    mail_email: str
    mail_psw: str
    mail_token_salt: str
    password_algorithm: str
    access_token_expire_minutes: int

settings = Settings()  # type: ignore

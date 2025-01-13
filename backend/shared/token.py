from config.config import settings
from itsdangerous import URLSafeTimedSerializer

SALT = settings.mail_token_salt
SECRET_KEY = settings.secret_key
MAIL_EMAIL = settings.mail_email
MAIL_PSW = settings.mail_psw

NOTIFFICATION_CREDS = settings.firebase_creds_path

serializer = URLSafeTimedSerializer(SECRET_KEY)

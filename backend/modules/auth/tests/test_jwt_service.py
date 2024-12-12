import unittest
from unittest.mock import patch, MagicMock
from datetime import datetime, timedelta, timezone
from jwt import encode as jwt_encode
from modules.auth.jwt_service import generate_jwt
from typing import Dict, Any

class TestGenerateJWT(unittest.TestCase):

    @patch("modules.auth.jwt_service.settings")
    @patch("modules.auth.jwt_service.jwt.encode")
    def test_generate_jwt_success(self, mock_jwt_encode, mock_settings):
        # Mock settings
        mock_settings.secret_key = "mock_secret"
        mock_settings.password_algorithm = "HS256"
        mock_settings.access_token_expire_minutes = 60

        payload = {"user_id": 123, "email": "test@example.com"}

        expected_token = "mocked_jwt_token"
        mock_jwt_encode.return_value = expected_token

        result = generate_jwt(payload)

        mock_jwt_encode.assert_called_once()
        self.assertEqual(result, expected_token)

    @patch("modules.auth.jwt_service.settings")
    @patch("modules.auth.jwt_service.jwt.encode")
    def test_generate_jwt_bytes_output(self, mock_jwt_encode, mock_settings):
        mock_settings.secret_key = "mock_secret"
        mock_settings.password_algorithm = "HS256"
        mock_settings.access_token_expire_minutes = 60

        payload = {"user_id": 123, "email": "test@example.com"}

        mock_jwt_encode.return_value = b"mocked_jwt_token"

        result = generate_jwt(payload)

        mock_jwt_encode.assert_called_once()
        self.assertEqual(result, "mocked_jwt_token")

    @patch("modules.auth.jwt_service.settings")
    def test_generate_jwt_expiration_time(self, mock_settings):
        mock_settings.secret_key = "mock_secret"
        mock_settings.password_algorithm = "HS256"
        mock_settings.access_token_expire_minutes = 60

        payload = {"user_id": 123, "email": "test@example.com"}

        with patch("modules.auth.jwt_service.jwt.encode") as mock_jwt_encode:
            generate_jwt(payload)

            args, kwargs = mock_jwt_encode.call_args
            encoded_payload = args[0]

            expected_exp_time = datetime.now(timezone.utc) + timedelta(minutes=60)
            self.assertAlmostEqual(encoded_payload["exp"].timestamp(), expected_exp_time.timestamp(), delta=1)

if __name__ == "__main__":
    unittest.main()

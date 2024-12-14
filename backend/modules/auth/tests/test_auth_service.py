import unittest
from unittest.mock import MagicMock, patch
from sqlalchemy.orm import Session
from shared.exceptions import AuthenticationFailedException, DuplicateEntity, InvalidToken, EntityNotFound
from shared.response_schemas import SuccessfulTokenPayload
from modules.auth.schemas import UserLogin
from modules.user.user_schemas import User, UserRegister, UserDTO
from modules.auth import jwt_service, password_service
from modules.user import user_service, user_repository
from modules.mail.mail_service import send_activation_token
from datetime import datetime, timezone
from shared.token import serializer, SALT
from modules.auth.auth_service import register_user, login, activate_account

class TestAuthFunctions(unittest.TestCase):

    def setUp(self):
        self.session = MagicMock(spec=Session)

    @patch("modules.user.user_service.get_user_by_email_as_entity")
    @patch("modules.auth.password_service.compare_password")
    @patch("modules.auth.jwt_service.generate_jwt")
    def test_login_success(self, mock_generate_jwt, mock_compare_password, mock_get_user_by_email):
        login_data = UserLogin(email="test@example.com", password="password123")
        user = User(id=1, email="test@example.com", password="hashed_password", is_active=True, creation_date=datetime.now(timezone.utc))

        mock_get_user_by_email.return_value = user
        mock_compare_password.return_value = True
        mock_generate_jwt.return_value = "mocked_token"

        result = login(self.session, login_data)

        self.assertIsInstance(result, SuccessfulTokenPayload)
        self.assertEqual(result.token, "mocked_token")

    @patch("modules.user.user_service.get_user_by_email_as_entity")
    @patch("modules.auth.password_service.compare_password")
    def test_login_failure_invalid_credentials(self, mock_compare_password, mock_get_user_by_email):
        login_data = UserLogin(email="test@example.com", password="wrong_password")
        user = User(id=1, email="test@example.com", password="hashed_password", is_active=True, creation_date=datetime.now(timezone.utc))

        mock_get_user_by_email.return_value = user
        mock_compare_password.return_value = False

        with self.assertRaises(AuthenticationFailedException):
            login(self.session, login_data)

    @patch("modules.user.user_service.get_user_by_email_as_dto")
    @patch("modules.user.user_repository.create_user")
    @patch("modules.mail.mail_service.send_activation_token")
    @patch("modules.auth.password_service.get_password_hash")
    def test_register_user_success(self, mock_get_password_hash, mock_send_activation_token, mock_create_user, mock_get_user_by_email):
        user_data = UserRegister(email="test@example.com", password="password123")
        mock_get_user_by_email.return_value = None
        mock_get_password_hash.return_value = "hashed_password"
        mock_create_user.return_value = User(id=1, email="test@example.com", password="hashed_password", is_active=True, creation_date=datetime.now(timezone.utc))

        result = register_user(self.session, user_data)

        self.assertIsInstance(result, UserDTO)
        self.assertEqual(result.email, "test@example.com")

    @patch("modules.user.user_service.get_user_by_email_as_dto")
    def test_register_user_duplicate_email(self, mock_get_user_by_email):
        user_data = UserRegister(email="test@example.com", password="password123")
        mock_get_user_by_email.return_value = UserDTO(id=1, email="test@example.com", is_active=False, creation_date=datetime.now(timezone.utc))

        with self.assertRaises(DuplicateEntity):
            register_user(self.session, user_data)

    @patch("modules.user.user_service.get_user_by_email_as_dto")
    @patch("modules.user.user_repository.activate_user")
    @patch("shared.token.serializer.loads")
    def test_activate_account_success(self, mock_serializer_loads, mock_activate_user, mock_get_user_by_email):
        mock_serializer_loads.return_value = "test@example.com"
        mock_get_user_by_email.return_value = UserDTO(id=3, email="test@example.com", is_active=False, creation_date=datetime.now(timezone.utc))

        result = activate_account(self.session, "valid_token")

        self.assertIsInstance(result, UserDTO)
        self.assertEqual(result.email, "test@example.com")
        self.assertTrue(result.is_active)

    @patch("shared.token.serializer.loads")
    def test_activate_account_invalid_token(self, mock_serializer_loads):
        mock_serializer_loads.side_effect = Exception("Invalid token")

        with self.assertRaises(InvalidToken):
            activate_account(self.session, "invalid_token")

    @patch("shared.token.serializer.loads")
    @patch("modules.user.user_service.get_user_by_email_as_dto")
    def test_activate_account_user_not_found(self, mock_get_user_by_email, mock_serializer_loads):
        mock_serializer_loads.return_value = "test@example.com"
        mock_get_user_by_email.return_value = None

        with self.assertRaises(EntityNotFound):
            activate_account(self.session, "valid_token")

if __name__ == "__main__":
    unittest.main()

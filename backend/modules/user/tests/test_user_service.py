import unittest
from config.logger_config import logger
from unittest.mock import MagicMock, patch
from sqlalchemy.orm import Session
from shared.exceptions import EntityNotFound
from modules.user.user_schemas import User, UserDTO
from modules.user import user_service
from datetime import datetime


class TestUserService(unittest.TestCase):

    def setUp(self):
        self.session = MagicMock(spec=Session)

        self.sample_user = User(
            id=1,
            email="test@example.com",
            password="hashed_password",
            is_active=True,
            creation_date=datetime.now()
        )

        self.sample_user_dto = UserDTO(
            id=1,
            email="test@example.com",
            is_active=True,
            creation_date=datetime.now()
        )

    @patch("modules.user.user_repository.get_user_by_email")
    def test_get_user_by_email_as_entity(self, mock_get_user_by_email):
        logger.info("testing get_user_by_email_as_entity")
        
        mock_get_user_by_email.return_value = self.sample_user
        user = user_service.get_user_by_email_as_entity(self.session, "test@example.com")

        self.assertEqual(user.email, "test@example.com")
        self.assertEqual(user.id, 1)

        mock_get_user_by_email.return_value = None
        with self.assertRaises(EntityNotFound):
            user_service.get_user_by_email_as_entity(self.session, "nonexistent@example.com")

    @patch("modules.user.user_repository.get_user_by_email")
    def test_get_user_by_email_as_dto(self, mock_get_user_by_email_as_dto):
        logger.info("testing get_user_by_email_as_dto")

        mock_get_user_by_email_as_dto.return_value = self.sample_user_dto

        user_dto = user_service.get_user_by_email_as_dto(self.session, "test@example.com")

        self.assertEqual(user_dto.email, "test@example.com")
        self.assertEqual(user_dto.id, 1)

        mock_get_user_by_email_as_dto.return_value = None
        with self.assertRaises(EntityNotFound):
            user_service.get_user_by_email_as_dto(self.session, "nonexistent@example.com")

    @patch("modules.user.user_repository.get_user_by_id")
    def test_get_user_by_id_as_entity(self, mock_get_user_by_id):
        logger.info("testing get_user_by_id_as_entity")

        mock_get_user_by_id.return_value = self.sample_user

        user = user_service.get_user_by_id_as_entity(self.session, 1)

        self.assertEqual(user.email, "test@example.com")
        self.assertEqual(user.id, 1)

        mock_get_user_by_id.return_value = None
        with self.assertRaises(EntityNotFound):
            user_service.get_user_by_id_as_entity(self.session, 999)

    @patch("modules.user.user_repository.get_user_by_id")
    def test_get_user_by_id_as_dto(self, mock_get_user_by_id_as_dto):
        logger.info("testing get_user_by_id_as_dto")

        mock_get_user_by_id_as_dto.return_value = self.sample_user_dto

        user_dto = user_service.get_user_by_id_as_dto(self.session, 1)

        self.assertEqual(user_dto.email, "test@example.com")
        self.assertEqual(user_dto.id, 1)

        mock_get_user_by_id_as_dto.return_value = None
        with self.assertRaises(EntityNotFound):
            user_service.get_user_by_id_as_dto(self.session, 999)

    @patch("modules.user.user_repository.get_all_users")
    def test_get_users(self, mock_get_users):
        logger.info("testing get_users")

        mock_get_users.return_value = [self.sample_user_dto]

        user_dtos = user_service.get_users(self.session, 1, 10)

        self.assertEqual(len(user_dtos), 1)
        self.assertEqual(user_dtos[0].email, "test@example.com")
        self.assertEqual(user_dtos[0].id, 1)

        mock_get_users.return_value = []
        user_dtos = user_service.get_users(self.session, 1, 10)
        self.assertEqual(user_dtos, [])


if __name__ == "__main__":
    unittest.main()

import unittest
from config.logger_config import logger
from datetime import datetime
from modules.user.user_schemas import User
from modules.user.user_mapper import user_to_DTO, userList_to_DTOList



class TestUserMapper(unittest.TestCase):

    def setUp(self):
        creation_date_value = datetime.now()
        self.sample_user = User(
            id=1,
            email="test@example.com",
            password="password123",
            is_active=True,
            creation_date=creation_date_value
        )
        self.sample_user_no_id = User(
            email="test@example.com",
            password="password123",
            is_active=True,
            creation_date=creation_date_value
        )
        self.sample_users = [
            self.sample_user,
            User(id=2, email="user2@example.com", password="password456", is_active=False, creation_date=creation_date_value)
        ]

    def test_user_to_DTO_with_id(self):
        logger.info("testing user_to_DTO")
        
        user_dto = user_to_DTO(self.sample_user)
        
        self.assertEqual(user_dto.id, self.sample_user.id)
        self.assertEqual(user_dto.email, self.sample_user.email)
        self.assertEqual(user_dto.is_active, self.sample_user.is_active)
        self.assertEqual(user_dto.creation_date, self.sample_user.creation_date)

    def test_user_to_DTO_no_id(self):
        logger.info("testing user_to_DTO no id")

        user_dto= user_to_DTO(self.sample_user_no_id)

        self.assertEqual(user_dto.id, 0)
    
    def test_userList_to_DTOList(self):
        logger.info("testing userList_to_DTOList")
        user_dtos = userList_to_DTOList(self.sample_users)
        
        self.assertEqual(len(user_dtos), len(self.sample_users))
        
        for i, user in enumerate(self.sample_users):
            user_dto = user_dtos[i]
            self.assertEqual(user_dto.id, user.id)
            self.assertEqual(user_dto.email, user.email)
            self.assertEqual(user_dto.is_active, user.is_active)
            self.assertEqual(user_dto.creation_date, user.creation_date)
    
    def test_userList_to_DTOList_empty(self):
        logger.info("testing userList_to_DTOList with empty list")

        user_dtos = userList_to_DTOList([])
        
        self.assertEqual(user_dtos, [])


if __name__ == "__main__":
    unittest.main()

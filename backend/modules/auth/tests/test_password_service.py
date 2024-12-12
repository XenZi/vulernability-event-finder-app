import unittest
from modules.auth.password_service import get_password_hash, compare_password, pwd_context


class TestPasswordService(unittest.TestCase):

    def test_get_password_hash(self):
        password = "secure_password"
        hashed_password = get_password_hash(password)

        self.assertNotEqual(password, hashed_password)
        self.assertTrue(pwd_context.verify(password, hashed_password))

    def test_compare_password_success(self):
        password = "secure_password"
        hashed_password = get_password_hash(password)

        result = compare_password(password, hashed_password)
        self.assertTrue(result)

    def test_compare_password_failure(self):
        password = "secure_password"
        hashed_password = get_password_hash(password)

        result = compare_password("wrong_password", hashed_password)
        self.assertFalse(result)

if __name__ == "__main__":
    unittest.main()

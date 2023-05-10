import pytest
from django.contrib.auth.models import User


@pytest.fixture(autouse=True)
def enable_db_access_for_all_tests(db):
    """
    This fixture enables database access for all tests.
    """
    pass


@pytest.fixture
def test_user():
    return User.objects.create_user(
        username="test_user", email="test_user@test.com", password="test_password"
    )

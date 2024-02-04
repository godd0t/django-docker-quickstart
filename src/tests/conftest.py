import pytest
from asgiref.sync import sync_to_async
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


@pytest.fixture
async def test_async_user():
    create_async_user = sync_to_async(User.objects.create_user)
    return await create_async_user(
        username="test_user",  # noqa
        email="test_user@test.com",  # noqa
        password="test_password",  # noqa
    )  # noqa

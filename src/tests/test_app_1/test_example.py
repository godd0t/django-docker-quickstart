def test_example(test_user):
    assert test_user.username == "test_user"
    assert test_user.email is not None


async def test_async_example(test_async_user):
    assert test_async_user.username == "test_user"
    assert test_async_user.email is not None

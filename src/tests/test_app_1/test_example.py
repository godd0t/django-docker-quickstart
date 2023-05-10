def test_example(test_user):
    assert test_user.username == "test_user"
    assert test_user.email is not None

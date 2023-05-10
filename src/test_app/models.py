from django.db import models  # noqa


class TestModel(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField()
    file = models.FileField(upload_to="test_app/files/")

    def __str__(self):
        return self.name

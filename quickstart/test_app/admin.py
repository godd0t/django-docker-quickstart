from django.contrib import admin

from quickstart.test_app.models import TestModel


@admin.register(TestModel)
class TestModelAdmin(admin.ModelAdmin):
    list_display = ("name", "description")

from django.contrib import admin

from test_app.models import TestModel


@admin.register(TestModel)
class TestModelAdmin(admin.ModelAdmin):
    list_display = ("name", "description")

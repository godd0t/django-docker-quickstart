from django.urls import path

from .views import health

urlpatterns = [
    path('health', health, name="health"),
]

"""
ASGI config for project_name project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/4.2/howto/deployment/asgi/
"""

import os

from django.core.asgi import get_asgi_application

APP_ENV = os.getenv("APP_ENV", "dev")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", f"project_name.settings.{APP_ENV}")

application = get_asgi_application()

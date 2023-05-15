"""
WSGI config for project_name project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/4.2/howto/deployment/wsgi/
"""

import os

from django.core.wsgi import get_wsgi_application

APP_ENV = os.getenv("APP_ENV", "dev")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", f"project_name.settings.{APP_ENV}")

application = get_wsgi_application()

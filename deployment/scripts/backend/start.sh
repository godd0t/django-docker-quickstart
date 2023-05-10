#!/bin/bash

# Run migrations, collect static files and start server
if [ "$APP_ENV" != "prod" ]; then
    python manage.py makemigrations --noinput
    python manage.py migrate --noinput
else
    python manage.py makemigrations --noinput
    python manage.py migrate --noinput
    python manage.py collectstatic --noinput
fi

gunicorn "$APP_NAME".wsgi:application --bind 0.0.0.0:"$APP_PORT" --workers 3 --timeout 60 --graceful-timeout 60 --log-level=info

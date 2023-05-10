#!/bin/bash

# Run migrations, collect static files and start server
if [ "$APP_ENV" != "prod" ]; then
    python manage.py makemigrations --noinput
    python manage.py migrate --noinput
    python manage.py runserver "$APP_HOST":"$APP_PORT"
else
    python manage.py makemigrations --noinput
    python manage.py migrate --noinput
    python manage.py collectstatic --noinput
    gunicorn "$APP_NAME".wsgi:application --bind "$APP_HOST":"$APP_PORT" --workers 3 --log-level=info
fi

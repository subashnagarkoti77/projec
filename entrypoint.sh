#!/bin/bash
set -e

echo "Waiting for PostgreSQL..."

while ! nc -z $DATABASE_HOST $DATABASE_PORT; do
  echo "Postgres is unavailable - sleeping"
  sleep 1
done

echo "Postgres is up - continuing..."

python manage.py migrate --noinput
python manage.py collectstatic --noinput

exec gunicorn book_management.wsgi:application --bind 0.0.0.0:8000 --workers 3



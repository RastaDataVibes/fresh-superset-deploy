#!/bin/bash
set -e

# Activate venv
. /app/.venv/bin/activate

# DB upgrade
superset db upgrade

# Create admin (skip if exists)
superset fab create-admin --username zaga --firstname zaga --lastname dat --email opiobethle@gmail.com --password zagadat || echo 'Admin exists'

# Init
superset init

# Push app context for Gunicorn (fixes "outside of application context")
python -c "
from superset.app import create_app
app = create_app()
with app.app_context():
    print('App context ready')
"

# Start Gunicorn
exec "$@"

#!/bin/bash
export FLASK_APP=app.py
export FLASK_ENV=production

# Run with Gunicorn
# --workers: Number of worker processes (2-4 x NUM_CORES recommended)
# --bind: IP:PORT to bind
# --access-logfile: Log file location (- for stdout)
# wsgi:app refers to the app variable in wsgi.py
gunicorn --workers=4 \
         --bind=0.0.0.0:5000 \
         --access-logfile=- \
         --error-logfile=- \
         wsgi:app

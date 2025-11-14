FROM apache/superset:4.1.3

# System deps
USER root
RUN apt-get update && apt-get install -y libpq-dev && apt-get clean && rm -rf /var/lib/apt/lists/*

# Python deps
USER superset
RUN pip install --no-cache-dir psycopg2-binary==2.9.9 pillow==10.3.0

# Copy config and entrypoint script
COPY superset_config.py /app/pythonpath/superset_config.py
COPY entrypoint.sh /app/docker/entrypoint.sh

# Set config path
ENV SUPERSET_CONFIG_PATH=/app/pythonpath/superset_config.py

# Use official entrypoint + our script
ENTRYPOINT ["/app/docker/entrypoint.sh"]
CMD ["gunicorn", "--worker-class", "sync", "-w", "4", "--timeout", "300", "-b", "0.0.0.0:8088", "--preload", "superset.app:create_app()"]

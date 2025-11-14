FROM apache/superset:4.1.3-lean

# Install Postgres driver
USER root
RUN apt-get update && \
    apt-get install -y libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install psycopg2
USER superset
RUN pip install --no-cache-dir psycopg2-binary==2.9.9

# Copy config
COPY superset_config.py /app/pythonpath/superset_config.py

# Auto-init + start (no shell needed)
CMD ["/bin/sh", "-c", \
     "superset db upgrade && \
      (superset fab create-admin --username zaga --firstname zaga --lastname dat --email opiobethle@gmail.com --password zagadat || echo 'Admin exists') && \
      superset init && \
      gunicorn --worker-class sync -w 4 --timeout 300 -b 0.0.0.0:8088 superset:app"]

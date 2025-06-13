#!/usr/bin/env sh

# Install the pg_cron extension in the PostgreSQL database. As this extension can only
# be installed in the "postgres" database, overriding the default database using the
# POSTGRES_DB environment variable would break the installation.
psql \
  --command 'create extension "pg_cron" schema pg_catalog;' \
  --user "${POSTGRES_USER:-postgres}" \
  --dbname postgres \
  --echo-queries

#!/usr/bin/env sh

# Install the pg_cron extension in the PostgreSQL database. As this extension can only
# be installed in the "postgres" database, overriding the default database using the
# POSTGRES_DB environment variable would break the installation.
psql \
  --dbname postgres \
  --echo-queries \
  --command 'create extension "pg_cron" schema pg_catalog;'

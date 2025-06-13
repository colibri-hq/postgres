create schema if not exists extensions;
create extension if not exists "isn" schema extensions;
create extension if not exists "vector" schema extensions;

create extension "pg_cron" schema pg_catalog;
grant usage on schema "cron" to postgres;

create extension "supabase_vault" cascade;

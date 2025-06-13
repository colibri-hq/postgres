\set original_ECHO :ECHO
\set ECHO queries

create schema if not exists extensions;
create extension if not exists "isn" schema extensions;
create extension if not exists "vector" schema extensions;
create extension "supabase_vault" cascade;

\set ECHO :original_ECHO

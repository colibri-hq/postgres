# syntax=docker/dockerfile:1
FROM postgres:17 AS base
FROM base AS builder
ARG VAULT_VERSION=0.3.1
ENV VAULT_VERSION=${VAULT_VERSION}

WORKDIR /build

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
  <<EOF
  set -eux
  apt-get update
  apt-get install --yes --no-install-recommends \
    "postgresql-server-dev-${PG_MAJOR}" \
    ca-certificates \
    build-essential \
    libsodium-dev \
    wget \
  ;
  wget --quiet --output-document=- \
    "https://github.com/supabase/vault/archive/refs/tags/v${VAULT_VERSION}.tar.gz" \
      | tar \
        --strip-components=1 \
        --directory=./ \
        --extract \
        --file=- \
        --gzip
  make --jobs=$(nproc)
EOF

FROM base
ENV POSTGRES_INITDB_ARGS="--set=shared_preload_libraries='supabase_vault, pg_cron' --set=include_dir='/etc/postgresql/'"

# Install runtime dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
  <<EOF
  set -eux
  apt-get update
  apt-get install --yes --no-install-recommends \
    "postgresql-${PG_MAJOR}-cron" \
    "postgresql-${PG_MAJOR}-pgvector" \
    libsodium23 \
  ;
EOF

COPY --link ./init.sql /docker-entrypoint-initdb.d/00_init.sql

# region Cron Extension
COPY --link ./pg_cron/pg_cron.conf /etc/postgresql/pg_cron.conf
# endregion

# region Supabase Vault Extension
COPY --link --from=builder /build/sql /usr/share/postgresql/17/extension/
COPY --link --from=builder /build/*.so /usr/lib/postgresql/17/lib/
COPY --link --from=builder /build/*.control* /usr/share/postgresql/17/extension/
COPY --link ./supabase_vault/supabase_vault.conf /etc/postgresql/supabase_vault.conf
COPY --link --chown=999:999 ./supabase_vault/pgsodium_get_key.sh /opt/pgsodium_get_key.sh
# endregion

STOPSIGNAL SIGINT
VOLUME ["/var/lib/postgresql/data"]
EXPOSE 5432
CMD ["postgres"]

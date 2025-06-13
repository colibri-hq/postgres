Colibri PostgreSQL Server
=========================
A PostgreSQL server Docker image for [Colibri](https://github.com/colibri-hq/colibri), a self-hosted, personal ebook
management platform. This image augments the official PostgreSQL image with additional extensions and configuration.

While it is primarily intended for use with Colibri, it can also be used as a general-purpose PostgreSQL server. The
image includes the following extensions:

- **[`supabase_vault`](https://github.com/supabase/vault):** To manage secrets and sensitive data.
- **[`pg_cron`](https://github.com/citusdata/pg_cron):** For scheduling periodic tasks within the database.
- **[`pgvector`](https://github.com/pgvector/pgvector):** For vector similarity search.
- **[`isn`](https://www.postgresql.org/docs/current/isn.html):** For International Standard Number (ISN) support.

Configuration
-------------
The image allows setting the libsodium root encryption key via three different ways:

1. **Docker Secret:** Mount a secret file containing the key at `/run/secrets/pgsodium_key`
2. **Secret file environment variable:** Set the environment variable `PGSODIUM_KEY_FILE` to the path of the secret file
3. **Environment variable:** Set the environment variable `PGSODIUM_KEY` to the key value directly

The key must be a 32-byte base64-encoded string. You can generate a key using the following command:

```bash
openssl rand -base64 32
```

### Additional Configuration Files

You can also mount additional configuration files into the container by mounting them to the `/etc/postgresql/`
directory, which is configured as an include directory in the main `postgresql.conf` file. This allows you to
add custom configurations or extensions without modifying the main configuration file.

### Advanced Customization

Refer to the [official PostgreSQL documentation](https://hub.docker.com/_/postgres) for the upstream image for more
advanced customization options.

Usage
-----
To use this image, you can run it with Docker Compose or directly with Docker:

```
ghcr.io/colibri-hq/postgres:latest
```

Below is an example of a Docker Compose file that sets up the PostgreSQL server with a custom configuration file and a
Docker Secret for the libsodium key:

```yaml
services:
  postgres:
    image: ghcr.io/colibri-hq/postgres:latest
    environment:
      POSTGRES_USER: colibri
      POSTGRES_PASSWORD: colibri
      PGSODIUM_KEY_FILE: /run/secrets/pgsodium_key
    secrets:
      - pgsodium_key
    volumes:
      - ./custom-config.conf:/etc/postgresql/
```

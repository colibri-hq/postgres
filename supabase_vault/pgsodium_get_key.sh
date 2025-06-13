#!/usr/bin/env sh

if [ -n "${PGSODIUM_KEY}" ]; then
  echo "${PGSODIUM_KEY}"
elif [ -n "${PGSODIUM_KEY_FILE}" ] && [ -f "${PGSODIUM_KEY_FILE}" ]; then
  cat "${PGSODIUM_KEY_FILE}"
elif [ -f /run/secrets/pgsodium_key ]; then
  cat /run/secrets/pgsodium_key
else
  echo "PGSODIUM_KEY not set or secret not found"
  exit 1
fi

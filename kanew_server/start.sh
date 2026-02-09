#!/bin/sh

set -e

cd /app

if [ -n "$RAILWAY_PUBLIC_DOMAIN" ] && [ -f "config/production.yaml" ]; then
  sed -i "s|%RAILWAY_PUBLIC_DOMAIN%|$RAILWAY_PUBLIC_DOMAIN|g" config/production.yaml
fi

if [ -f "config/production.yaml" ]; then
  DB_HOST_VALUE="${DB_HOST:-}"
  DB_PORT_VALUE="${DB_PORT:-}"
  DB_NAME_VALUE="${DB_NAME:-}"
  DB_USER_VALUE="${DB_USER:-}"
  DB_REQUIRE_SSL_VALUE="${DB_REQUIRE_SSL:-}"

  if [ -z "$DB_HOST_VALUE" ] || [ -z "$DB_PORT_VALUE" ] || [ -z "$DB_NAME_VALUE" ] || [ -z "$DB_USER_VALUE" ]; then
    if [ -n "${DATABASE_URL:-}" ]; then
      # Example: postgresql://user:pass@host:5432/dbname
      URL_NO_SCHEME="${DATABASE_URL#*://}"
      USERPASS="${URL_NO_SCHEME%%@*}"
      HOSTPATH="${URL_NO_SCHEME#*@}"

      URL_USER="${USERPASS%%:*}"
      HOSTPORT="${HOSTPATH%%/*}"
      URL_DB="${HOSTPATH#*/}"
      URL_DB="${URL_DB%%\?*}"

      URL_HOST="${HOSTPORT%%:*}"
      URL_PORT="${HOSTPORT#*:}"
      if [ "$URL_PORT" = "$HOSTPORT" ]; then
        URL_PORT="5432"
      fi

      DB_HOST_VALUE="${DB_HOST_VALUE:-$URL_HOST}"
      DB_PORT_VALUE="${DB_PORT_VALUE:-$URL_PORT}"
      DB_NAME_VALUE="${DB_NAME_VALUE:-$URL_DB}"
      DB_USER_VALUE="${DB_USER_VALUE:-$URL_USER}"
    else
      DB_HOST_VALUE="${DB_HOST_VALUE:-${PGHOST:-postgres.railway.internal}}"
      DB_PORT_VALUE="${DB_PORT_VALUE:-${PGPORT:-5432}}"
      DB_NAME_VALUE="${DB_NAME_VALUE:-${PGDATABASE:-railway}}"
      DB_USER_VALUE="${DB_USER_VALUE:-${PGUSER:-postgres}}"
    fi
  fi

  DB_REQUIRE_SSL_VALUE="${DB_REQUIRE_SSL_VALUE:-false}"
  sed -i "s|%DB_HOST%|$DB_HOST_VALUE|g" config/production.yaml
  sed -i "s|%DB_PORT%|$DB_PORT_VALUE|g" config/production.yaml
  sed -i "s|%DB_NAME%|$DB_NAME_VALUE|g" config/production.yaml
  sed -i "s|%DB_USER%|$DB_USER_VALUE|g" config/production.yaml
  sed -i "s|%DB_REQUIRE_SSL%|$DB_REQUIRE_SSL_VALUE|g" config/production.yaml

  REDIS_ENABLED_VALUE="false"
  if [ "${REDIS_ENABLED:-}" = "true" ]; then
    REDIS_ENABLED_VALUE="true"
  fi
  sed -i "s|%REDIS_ENABLED%|$REDIS_ENABLED_VALUE|g" config/production.yaml
fi

echo "========================================="
echo "Starting Kanew Serverpod Backend"
echo "========================================="

if [ ! -x "./server" ]; then
  echo "ERROR: ./server executable not found"
  ls -la
  exit 1
fi

if [ -d "migrations" ]; then
  echo "Migrations directory found"
else
  echo "ERROR: migrations directory not found"
  exit 1
fi

echo "========================================="
echo "Step 1: Applying Database Migrations"
echo "========================================="
./server --mode="$runmode" --server-id="$serverid" --logging="$logging" --role="$role" --apply-migrations

echo "========================================="
echo "Step 2: Starting Server"
echo "========================================="
exec ./server --mode="$runmode" --server-id="$serverid" --logging="$logging" --role="$role"


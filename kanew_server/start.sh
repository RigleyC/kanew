#!/bin/sh

set -e

cd /app

if [ -n "$RAILWAY_PUBLIC_DOMAIN" ] && [ -f "config/production.yaml" ]; then
  sed -i "s|%RAILWAY_PUBLIC_DOMAIN%|$RAILWAY_PUBLIC_DOMAIN|g" config/production.yaml
fi

if [ -f "config/production.yaml" ]; then
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


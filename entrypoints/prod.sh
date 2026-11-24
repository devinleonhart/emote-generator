#!/bin/sh

set -e

echo "Environment: $RAILS_ENV"

bundle check

if [ ! -d "${ASSETS_DIR:=/app/assets}/emotes" ]; then
  echo "ASSETS_DIR ($ASSETS_DIR) has no emotes directory"
  exit 1
fi

# Migrations are a separate command, never run here.
exec bundle exec "$@"

#!/bin/sh
set -e

# Uncomment to run DB migrations before start (idempotent):
# yarn db:migrate

exec "$@"

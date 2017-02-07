#!/bin/sh
set -eu

# expose credentials to docker-entrypoint
CREDENTIALS="/etc/postgres-credentials"

if [ -z "${POSTGRES_PASSWORD:-}" -a -r "${CREDENTIALS}/password" ]; then
    POSTGRES_PASSWORD="$(cat ${CREDENTIALS}/password)"
fi

[ -n "$POSTGRES_PASSWORD" ] || exit 111

export POSTGRES_PASSWORD
exec /docker-entrypoint.sh "postgres"

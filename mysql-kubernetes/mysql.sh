#!/bin/sh
set -eu

# expose credentials to docker-entrypoint
CREDENTIALS="/etc/mysql-credentials"

if [ -z "${MYSQL_ROOT_PASSWORD:-}" -a -r "${CREDENTIALS}/password" ]; then
    MYSQL_ROOT_PASSWORD="$(cat ${CREDENTIALS}/password)"
fi

[ -n "$MYSQL_ROOT_PASSWORD" ] || exit 111

export MYSQL_ROOT_PASSWORD
exec /docker-entrypoint.sh "mysqld"

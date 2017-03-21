#!/bin/sh
set -eu

exec \
    chpst -u sensu \
    sensu-server \
    --validate_config \
    -c /etc/sensu/config.json \
    -d /etc/sensu/conf.d,/etc/sensu/secrets

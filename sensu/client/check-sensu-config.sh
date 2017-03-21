#!/bin/sh
set -eu

exec \
    chpst -u sensu \
    sensu-client \
    --validate_config \
    -c /etc/sensu/client.json \
    -d /etc/sensu/conf.d,/etc/sensu/secrets

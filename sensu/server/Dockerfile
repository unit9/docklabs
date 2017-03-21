FROM unit9/sensu-base:latest
MAINTAINER Kamil Cholewiński <kamil.cholewinski@unit9.com>

COPY check-sensu-config.sh /etc/rc.local.d/99-check-sensu-config
COPY sensu-server.run /etc/service/sensu-server/run
COPY sensu-api.run /etc/service/sensu-api/run

EXPOSE 4567

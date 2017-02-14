FROM unit9/cron:latest
MAINTAINER Kamil Cholewiński <kamil.cholewinski@unit9.com>

RUN echo 'deb http://cdn.debian.net/debian/ jessie-backports main' \
    > /etc/apt/sources.list.d/jessie-backports.list

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends --yes \
        postgresql-client-9.6/jessie-backports \
    && rm -rf /var/cache/apt /var/lib/apt/lists

ENV PGUSER="postgres"      \
    PGPASSWORD="postgres"  \
    PGHOST="postgres"      \
    PGPORT="5432"

ADD dumper.cron /etc/cron.daily/50-dumper
VOLUME /var/backups

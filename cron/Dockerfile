FROM unit9/base:latest
MAINTAINER Kamil Cholewiński <kamil.cholewinski@unit9.com>

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends --yes \
        cron \
        socklog \
    && rm -f /etc/cron.*/* \
    && rm -rf /var/cache/apt /var/lib/apt/lists

ADD crontab      /etc/crontab
ADD cron.run     /etc/service/cron/run
ADD socklog.run  /etc/service/socklog/run

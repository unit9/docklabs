FROM unit9/base:latest
MAINTAINER Kamil Cholewiński <kamil.cholewinski@unit9.com>

RUN curl -fsS https://sensu.global.ssl.fastly.net/apt/pubkey.gpg \
    | apt-key add - \
    && echo "deb https://sensu.global.ssl.fastly.net/apt sensu main" \
    > /etc/apt/sources.list.d/sensu.list \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
       uchiwa \
    && rm -rf /var/cache/apt /var/lib/apt/lists \
    && ls -ld /opt/uchiwa/bin/uchiwa

COPY uchiwa.run /etc/service/uchiwa/run
EXPOSE 3000

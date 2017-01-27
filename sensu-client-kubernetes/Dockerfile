FROM unit9/sensu-client:latest
MAINTAINER Kamil Cholewiński <kamil.cholewinski@unit9.com>

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
       build-essential \
    && rm -rf /var/cache/apt /var/lib/apt/lists \
    && /opt/sensu/embedded/bin/gem install \
       sensu-plugins-kubernetes \
    && ls -ld /opt/sensu/embedded/bin/check-*

FROM unit9/base:latest
MAINTAINER Kamil Cholewiński <kamil.cholewinski@unit9.com>

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
            nginx-light \
    && rm -rf /var/cache/apt /var/lib/apt/lists
ADD nginx.run  /etc/service/nginx/run
ADD rc.local   /etc/rc.local
ADD nginx.conf /etc/nginx/nginx.conf

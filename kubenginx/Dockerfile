from unit9/base:latest
maintainer Kamil Cholewiński <kamil.cholewinski@unit9.com>

run apt-get update && \
    apt-get install --yes --no-install-recommends \
            nginx-light \
    && rm -rf /var/cache/apt /var/lib/apt/lists
add nginx.run  /etc/service/nginx/run
add rc.local   /etc/rc.local
add nginx.conf /etc/nginx/nginx.conf

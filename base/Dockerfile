from debian:jessie
maintainer Kamil Cholewiński <kamil@unit9.com>

run apt-get update && \
    apt-get dist-upgrade --yes && \
    apt-get install --no-install-recommends --yes \
            apt-transport-https \
            bzip2 \
            ca-certificates \
            curl \
            runit \
            && \
    rm -rf /var/cache/apt

add docker-init /sbin/docker-init
cmd ["/sbin/docker-init"]

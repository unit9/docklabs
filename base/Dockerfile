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

add https://github.com/peterbourgon/runsvinit/releases/download/v2.0.0/runsvinit-linux-amd64.tgz /tmp/runsvinit.tgz
run cd /sbin && tar zxf /tmp/runsvinit.tgz && rm /tmp/runsvinit.tgz
cmd ["/sbin/runsvinit"]

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

run curl -fsSL -o /tmp/runsvinit.tgz \
    https://github.com/peterbourgon/runsvinit/releases/download/v2.0.0/runsvinit-linux-amd64.tgz \
    && sha256sum /tmp/runsvinit.tgz \
    && cd /sbin \
    && tar zxf /tmp/runsvinit.tgz \
    && chown root:root /sbin/runsvinit \
    && rm /tmp/runsvinit.tgz
add rc rc.local /etc/
cmd ["/etc/rc"]

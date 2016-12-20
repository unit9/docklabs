from unit9/base:latest
maintainer Kamil Cholewinski <kamil.cholewinski@unit9.com>

run apt-key adv \
    --keyserver hkp://ha.pool.sks-keyservers.net:80 \
    --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
run echo 'deb https://apt.dockerproject.org/repo debian-jessie main' \
     > /etc/apt/sources.list.d/docker.list
run apt-get update && \
    apt-get dist-upgrade --yes && \
    apt-get install --no-install-recommends --yes \
            docker-engine \
            && \
    rm -rf /var/cache/apt /var/lib/apt/lists/

add rc.local /etc/rc.local

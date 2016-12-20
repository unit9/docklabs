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
            python-werkzeug \
            && \
    rm -rf /var/cache/apt /var/lib/apt/lists/

volume /var/run/docker.sock

expose 8600
add rc.local /etc/rc.local
add run /etc/service/inspector/run
add main.py /app/main.py

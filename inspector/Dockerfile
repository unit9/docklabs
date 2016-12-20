from unit9/dind:latest
maintainer Kamil Cholewinski <kamil.cholewinski@unit9.com>

run apt-get update && \
    apt-get dist-upgrade --yes && \
    apt-get install --no-install-recommends --yes \
            python-werkzeug \
            && \
    rm -rf /var/cache/apt /var/lib/apt/lists/

expose 8600
add run /etc/service/inspector/run
add main.py /app/main.py

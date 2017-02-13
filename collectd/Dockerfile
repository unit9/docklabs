FROM unit9/base:latest

MAINTAINER Artiom Vasiliev <artiom@unit9.com>

COPY ["configs/sources.list", "/etc/apt/sources.list"]
COPY ["facette.rc", "/etc/service/facette/run"]

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential libgcrypt20-dev librrd-dev snmp \
        libsnmp-dev snmp-mibs-downloader && \
    rm -rf /var/cache/apt /var/lib/apt/lists && \
    chmod +x /etc/service/facette/run && \
    cd /tmp && \
    # install collectd
    curl -LO https://storage.googleapis.com/collectd-tarballs/collectd-5.7.1.tar.bz2 && \
    tar xjf collectd-5.7.1.tar.bz2 && \
    rm collectd-5.7.1.tar.bz2 && \
    cd collectd-5.7.1 && \
    ./configure --with-librrd --enable-librrd --with-snmp --enable-snmp && \
    make && \
    make install && \
    cd /tmp && \
    rm -r collectd-5.7.1 && \
    # install facette
    curl -LO https://github.com/facette/facette/releases/download/0.3.0/facette_0.3.0-1.jessie_amd64.deb && \
    dpkg -i facette_0.3.0-1.jessie_amd64.deb && \
    rm facette_0.3.0-1.jessie_amd64.deb && \
    mkdir /var/run/facette/ && \
    # cleanup
    apt-get remove --purge -y build-essential && \
    apt-get autoremove -y

COPY ["configs/facette.json", "/etc/facette/facette.json"]
COPY ["configs/providers_collectd.json", "/etc/facette/providers/collectd.json"]

EXPOSE 80

CMD ["/opt/collectd/sbin/collectd", "-C", "/opt/collectd/etc/collectd.conf", "-f"]

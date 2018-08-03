FROM debian:9-slim as socklog-builder

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --yes \
    make \
    gcc \
    wget

WORKDIR /root
RUN wget http://smarden.org/socklog2/socklog-2.0.3.tar.gz && \
    tar xvfz socklog-2.0.3.tar.gz && \
    cd admin/socklog-2.0.3 && \
    package/install

FROM debian:9-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get dist-upgrade --yes && \
    apt-get install --no-install-recommends --yes \
            apt-transport-https \
            bzip2 \
            ca-certificates \
            curl \
            runit \
            && \
    rm -rf /var/cache/apt /var/lib/apt/lists

RUN curl -fsSL -o /tmp/runsvinit.tgz \
    https://github.com/peterbourgon/runsvinit/releases/download/v2.0.0/runsvinit-linux-amd64.tgz \
    && sha256sum /tmp/runsvinit.tgz \
    && cd /sbin \
    && tar zxf /tmp/runsvinit.tgz \
    && chown root:root /sbin/runsvinit \
    && rm /tmp/runsvinit.tgz

COPY --from=socklog-builder /root/admin/socklog/command/socklog /sbin/
COPY --from=socklog-builder /root/admin/socklog/command/socklog-check /sbin/
COPY --from=socklog-builder /root/admin/socklog/command/socklog-conf /sbin/
COPY --from=socklog-builder /root/admin/socklog/command/tryto /sbin/
COPY --from=socklog-builder /root/admin/socklog/command/uncat /sbin/

ADD rc rc.local /etc/
ADD socklog.run /etc/service/socklog/run
CMD ["/etc/rc"]

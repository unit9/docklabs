FROM postgres:9.5
MAINTAINER Kamil Cholewiński <kamil.cholewinski@unit9.com>

COPY postgres.sh /postgres.sh
RUN chmod +x /postgres.sh && \
    chmod +x /docker-entrypoint.sh

VOLUME ["/var/lib/postgresql/data", "/etc/postgres-credentials"]

CMD ["/postgres.sh"]

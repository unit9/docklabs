FROM unit9/base:latest

MAINTAINER Krzysztof Skoracki <krzysztof.skoracki@unit9.com>

COPY ["nginx.rc", "/etc/service/nginx/run"]

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
            nginx-light \
    && rm -rf /var/cache/apt /var/lib/apt/lists

EXPOSE 80

COPY ["nginx.conf", "/etc/nginx/sites-available/default"]

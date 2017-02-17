FROM unit9/base:latest

MAINTAINER Artiom Vasiliev <artiom@unit9.com>

COPY ["php-fpm.rc", "/etc/service/php-fpm/run"]
COPY ["nginx.rc", "/etc/service/nginx/run"]

RUN apt-get update && \
    apt-get install -y nginx php5 php5-common php5-curl php5-fpm php5-gd \
        php5-mysql php5-xmlrpc php5-xcache php5-memcache && \
    rm -rf /var/cache/apt /var/lib/apt/lists/*

EXPOSE 80

COPY ["nginx.conf", "/etc/nginx/sites-available/default"]

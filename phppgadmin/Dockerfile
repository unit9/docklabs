FROM dockage/phppgadmin:latest

MAINTAINER Remigiusz Boguszewicz <remigiusz.boguszewicz@unit9.com>

# Install apache utils that provide htpasswd and enable basic http auth
RUN apk update && \
    apk add apache2-utils && \
    sed -i "s|index.php?\$args;|index.php?\$args;\n\tauth_basic\ \"Private\ Property\";\n\tauth_basic_user_file /etc/nginx/.htpasswd;|" /etc/dockage/runtime/configs/nginx/default.conf

ADD entrypoint /sbin/entrypoint

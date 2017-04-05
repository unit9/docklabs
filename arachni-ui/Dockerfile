FROM unit9/base:latest

MAINTAINER Artiom Vasiliev <artiom@unit9.com>

RUN cd /tmp \
    && curl -LO https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && tar xjf phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/ \
    && rm -r phantomjs-2.1.1-linux-x86_64 \
    && curl -LO https://github.com/Arachni/arachni/releases/download/v1.5.1/arachni-1.5.1-0.5.12-linux-x86_64.tar.gz \
    && tar xzvf arachni-1.5.1-0.5.12-linux-x86_64.tar.gz \
    && rm arachni-1.5.1-0.5.12-linux-x86_64.tar.gz \
    && mv arachni-1.5.1-0.5.12 /app \
    && rm /app/system/arachni-ui-web/config/environments/development.rb \
    && rm /app/system/arachni-ui-web/config/environments/test.rb

COPY rc.local /etc/rc.local
COPY web.run /etc/service/arachni_web/run
COPY postgres_setup /app/bin/postgres_setup

EXPOSE 7331 9292

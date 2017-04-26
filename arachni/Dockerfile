FROM unit9/python-uwsgi:latest

MAINTAINER Artiom Vasiliev <artiom@unit9.com>

RUN apt-get update \
    && apt-get install -y build-essential \
    && rm -rf /var/cache/apt /var/lib/apt/lists/*

# Install redis and arachni
RUN cd /tmp \
    && curl -LO http://download.redis.io/redis-stable.tar.gz \
    && tar xvzf redis-stable.tar.gz \
    && cd redis-stable \
    && make \
    && make install \
    && cd /tmp \
    && rm -rf redis-stable \
    && curl -LO https://github.com/Arachni/arachni/releases/download/v1.5.1/arachni-1.5.1-0.5.12-linux-x86_64.tar.gz \
    && tar xzvf arachni-1.5.1-0.5.12-linux-x86_64.tar.gz \
    && sed -i "s/marshal/txt/" arachni-1.5.1-0.5.12/system/gems/gems/arachni-1.5.1/components/plugins/email_notify.rb \
    && mv arachni-1.5.1-0.5.12 /scanner \
    && chmod -R 777 /scanner/system/arachni-ui-web/config/component_cache \
        /scanner/system/arachni-ui-web/db \
        /scanner/system/arachni-ui-web/tmp \
        /scanner/system/logs \
        /scanner/system/home

# Install app requirements
COPY app/requirements.txt /app
RUN pip install -r /app/requirements.txt

COPY app /app

WORKDIR /app

COPY redis.conf /etc/
COPY redis.run /etc/service/redis/run
COPY celery.run /etc/service/celery/run
COPY web.run /etc/service/web/run

ENV SCANNER_PATH=/scanner/bin/arachni \
    SCANNER_REPORT_PATH=/tmp \
    PORT=5000
    
EXPOSE 5000

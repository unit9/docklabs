FROM unit9/cron:latest
MAINTAINER Artiom Vasiliev <artiom@unit9.com>

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends --yes \
        mysql-client \
        python \
    && rm -rf /var/cache/apt /var/lib/apt/lists

RUN set -x \
    && curl -fsS -o /tmp/sdk.tar.gz \
    https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.tar.gz \
    && cd /opt \
    && tar zxf /tmp/sdk.tar.gz \
    && rm /tmp/sdk.tar.gz \
    && google-cloud-sdk/install.sh --quiet \
    && ln -s /opt/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud \
    && gcloud --quiet config set disable_usage_reporting true \
    && gcloud --quiet components install \
       gsutil \
    && ln -s /opt/google-cloud-sdk/bin/gsutil /usr/local/bin/gsutil \
    && gcloud --version \
    && gsutil --version \
    && true

ENV MYSQL_USER="root" \
    MYSQL_PASSWORD="" \
    MYSQL_HOST="localhost" \
    MYSQL_PORT="3306" \
    BOTO_PATH="" \
    GS_PATH="" \
    GOOGLE_APPLICATION_CREDENTIALS=""

ADD dumper.cron /etc/cron.daily/50-dumper
ADD uploader.cron /etc/cron.daily/60-uploader
ADD rc.local /etc/rc.local
VOLUME /var/backups

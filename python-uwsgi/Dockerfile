FROM unit9/base:latest

MAINTAINER Kamil Cholewiński <kamil.cholewinski@unit9.com>
MAINTAINER Artiom Vasiliev <artiom@unit9.com>

# Dependencies
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
            python-all-dev \
            python-pip \
            python-wheel \
            uwsgi-plugin-python \
            lsb-release \
    && rm -rf /var/cache/apt

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
    && export CLOUD_DEB="deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" \
    && echo $CLOUD_DEB > /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | apt-key add - \
    && apt-get update \
    && apt-get install -y google-cloud-sdk

RUN pip install awscli

# Create the space for the app
RUN mkdir /app
WORKDIR /app

# Add "app" user to run uWSGI as
RUN adduser --system --no-create-home --disabled-login --group app

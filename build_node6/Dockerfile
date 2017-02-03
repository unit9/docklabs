FROM unit9/base:latest
MAINTAINER Krzysztof Skoracki <krzysztof.skoracki@unit9.com>

RUN curl -O https://deb.nodesource.com/setup_6.x && \
    bash setup_6.x && \
    rm setup_6.x

RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-jessie main" > /etc/apt/sources.list.d/google-cloud-sdk.list

RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        build-essential \
        git-core \
        python-dev \
        python-pip \
        python-wheel \
        libpng-dev \
        nodejs \
        google-cloud-sdk \
    && rm -rf /var/cache/apt /var/lib/apt/lists

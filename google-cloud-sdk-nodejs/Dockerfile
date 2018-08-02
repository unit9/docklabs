FROM google/cloud-sdk:latest

MAINTAINER remik <remigiusz.boguszewicz@unit9.com>

WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
        apt-get install --yes --no-install-recommends \
            fortunes \
            cowsay \
            git \
            nodejs \
            gcc \
            g++ \
            make \
            build-essential \
    && rm -rf /var/lib/apt/lists/*


RUN apt-get clean

CMD /usr/games/fortune -a | cowsay


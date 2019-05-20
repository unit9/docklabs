FROM debian:9

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get -y install curl \
    && curl -o /tmp/node_setup https://deb.nodesource.com/setup_10.x \
    && bash /tmp/node_setup \
    && apt-get -y install nodejs \
    && npm install -g yarn \
    && apt-get -y install libsqlite3-dev libssl-dev git-core default-libmysqlclient-dev libpq-dev libpng-dev python-pip python3-pip libc6:i386 lib32z1 gconf-service \
    libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
    libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 \
    libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 \
    libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 \
    libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 \
    libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 \
    libnss3 lsb-release xdg-utils wget libffi-dev \
    && cd /usr/src \
    && wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz \
    && tar xzf Python-3.7.3.tgz \
    && cd Python-3.7.3 \
    && ./configure --enable-optimizations --with-ssl \
    && make altinstall \
    && cp /usr/local/bin/pip3.7 /usr/bin/pip3 \
    && cp /usr/local/bin/python3.7 /usr/bin/python3 \
    && mv /usr/bin/lsb_release /usr/bin/lsb_release_back

CMD ['tail -f /dev/null']
### AUTOGENERATED - DO NOT EDIT
### INSTEAD EDIT THE FILE parts/Dockerfile-header
from unit9/base:latest
maintainer Kamil Cholewiński <kamil.cholewinski@unit9.com>

workdir /app
run adduser --system \
    --home /app --no-create-home \
    --disabled-login --group app \
    --uid 999
### AUTOGENERATED - DO NOT EDIT
### INSTEAD EDIT THE FILE parts/Dockerfile-py27
run apt-get update && \
    apt-get install --yes --no-install-recommends \
            python-all-dev \
            python-pip \
            python-wheel \
            uwsgi-plugin-python \
    && rm -rf /var/cache/apt /var/lib/apt/lists
run pip install -U pip wheel

env PORT=5000
env PYTHON_MODULE=backend
env PYTHON_CALLABLE=app
### AUTOGENERATED - DO NOT EDIT
### INSTEAD EDIT THE FILE parts/Dockerfile-node7
arg node_release=node_7.x
run curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
    | apt-key add - \
    && echo "deb https://deb.nodesource.com/$node_release jessie main" \
    > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -qq nodejs \
    && rm -rf /var/cache/apt /var/lib/apt/lists \
    && echo "nodejs: $(nodejs --version)" \
    && echo "npm: $(npm --version)"
run npm install -g http-server
### AUTOGENERATED - DO NOT EDIT
### INSTEAD EDIT THE FILE parts/Dockerfile-footer
add run /etc/service/backend/run
### AUTOGENERATED - DO NOT EDIT
### RUN THIS TO GENERATE: ./web/generate
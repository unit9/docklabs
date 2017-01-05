from unit9/base:latest
maintainer Kamil Cholewiński <kamil.cholewinski@unit9.com>

# Dependencies
run apt-get update && \
    apt-get install --yes --no-install-recommends \
            python-all-dev \
            python-pip \
            python-wheel \
            uwsgi-plugin-python \
    && rm -rf /var/cache/apt

# Create the space for the app
run mkdir /app
workdir /app

# Add "app" user to run uWSGI as
run adduser --system --no-create-home --disabled-login --group app

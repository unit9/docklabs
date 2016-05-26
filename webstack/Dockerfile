from unit9/python-uwsgi:latest
maintainer Kamil Cholewiński <kamil.cholewinski@unit9.com>

# Add NodeJS apt repository
run curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
    | apt-key add - \
    && echo "deb https://deb.nodesource.com/node_4.x jessie main" \
    > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && rm -rf /var/cache/apt

# Install OS-level essentials
run apt-get install --yes --no-install-recommends \
            git-core \
            nodejs \
            ruby \
            ruby-dev \
            ruby-ffi \
    && rm -rf /var/cache/apt

# Frontend development tools
run gem install compass scss_lint
run npm install --global gulp-cli bower

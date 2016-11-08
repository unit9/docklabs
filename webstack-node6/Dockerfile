from unit9/python-uwsgi:latest
maintainer Kamil Cholewiński <kamil.cholewinski@unit9.com>

# Install NodeJS
RUN curl https://deb.nodesource.com/setup_6.x -o /tmp/node.sh \
    && bash /tmp/node.sh \
    && apt-get install --yes nodejs \
    && rm -rf /var/cache/apt

# Install OS-level essentials
run apt-get install --yes --no-install-recommends \
            git-core \
            ruby \
            ruby-dev \
            ruby-ffi \
    && rm -rf /var/cache/apt

# Frontend development tools
run gem install compass scss_lint
run npm install --global gulp-cli bower

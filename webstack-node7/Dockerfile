from unit9/python-uwsgi:latest
maintainer Kamil Cholewiński <kamil.cholewinski@unit9.com>
maintainer Artiom Vasiliev <artiom@unit9.com>

# Install NodeJS
RUN curl https://deb.nodesource.com/setup_7.x -o /tmp/node.sh \
    && bash /tmp/node.sh \
    && apt-get install --yes nodejs \
    && rm -rf /var/cache/apt

# Install OS-level essentials
RUN apt-get install --yes --no-install-recommends \
    git-core \
    ruby \
    ruby-dev \
    ruby-ffi \
    && rm -rf /var/cache/apt

# Frontend development tools
RUN gem install compass scss_lint
RUN npm install --global gulp-cli bower

# Base image with Python, uWSGI, Node, Ruby, & frontend tools

See the following base images for a full introduction:

- [`unit9/base`](https://github.com/unit9/docklabs/tree/master/base)
- [`unit9/python-uwsgi`](https://github.com/unit9/docklabs/tree/master/python-uwsgi)

This image adds standard frontend build tools.

## Features

- Latest stable releases of Node 4.x, Ruby 2.1
- Frontend development tools: Compass, Gulp, Bower
- Ready to build your frontend apps!

## Using with your `Dockerfile`

Pull `unit9/webstack:latest` and customise this example:

```
from unit9/webstack:latest
maintainer You <you@example.com>

# Install backend app requirements
add requirements.txt /app
run pip install -r ./requirements.txt

# Service definition for runit
add run_my_app /etc/service/my_app/run
env PORT=5000
expose 5000

# Install frontend build dependencies via NPM
add package.json /app
run npm install

# Slurp application code
add . /app

# Install frontend build dependencies via bower
run bower install --allow-root -q

# Build frontend
run gulp

```

Notice that neither `cmd` or `exec` are defined; refer to the
documentation for `unit9/base` for an explanation why.

Inside the file `run_my_app`, there should be a shell script that
reads the environment and sets up the uWSGI service; refer to the
documentation for `unit9/python-uwsgi` for details.

## License

See the file [`LICENSE`][/LICENSE].

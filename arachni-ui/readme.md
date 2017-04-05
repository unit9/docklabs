# Arachni security scanner

This image installs [`arachni`](http://www.arachni-scanner.com) security
scanner. Arachni is a feature-full, modular, high-performance Ruby framework
aimed towards helping penetration testers and administrators evaluate the
security of modern web applications.

This image starts web ui on port 80.

## Database

By default if you do not pass any parameters to `docker run`, arachni will use
local SQLite database. If you want to use Postgres, pass the following
arguments:

* PG_HOST
* PG_DATABASE
* PG_USERNAME
* PG_PASSWORD

For example:

```
docker run -d -p 80:80 --name arachni \
    -e PG_HOST=192.168.50.1 -e PG_DATABASE=arachni \
    -e PG_USERNAME=postgres -e PG_PASSWORD=arachni \
    unit9/arachni-ui:latest
```

Arachni will try to connect to your Postgres instance and check if the database
already exists, if not it will be created and the initial migrations applied.
Use the default [credentials](https://github.com/Arachni/arachni-ui-web/wiki/database)
to login.

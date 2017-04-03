# Arachni security scanner

This image installs [`arachni`](http://www.arachni-scanner.com) security
scanner. Arachni is a feature-full, modular, high-performance Ruby framework
aimed towards helping penetration testers and administrators evaluate the
security of modern web applications.

Web and REST API services are started on ports `9292` and `7331` respectively.
Backend is using the default SQLite database with the default
[credentials](https://github.com/Arachni/arachni-ui-web/wiki/database). Do not
forget to change. API is not using any authentication either so use NGINX or
some other proxy to add authentication if needed.

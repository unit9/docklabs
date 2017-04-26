# Arachni security scanner

This image installs [`arachni`](http://www.arachni-scanner.com) security
scanner. Arachni is a feature-full, modular, high-performance Ruby framework
aimed towards helping penetration testers and administrators evaluate the
security of modern web applications.

Due to the difference in the way cli version of the scanner works over
the API, this image is using a very simple web UI to launch the console
scanner.

Frontend is written in [`Flask`](http://flask.pocoo.org/),
[`Celery`](http://www.celeryproject.org/), and [`Redis`](https://redis.io/).
Celery is using a single worker so only one instance of the scanner can run
at the same time.

After the scan completion an email report is sent using Amazon SES. Because
the html report is too big and other versions are not human-friendly, the
scanner source code has been patched to allow plain text reports.

Web UI is running on port 5000.

## Running the image

You need to pass the following environment variables:

- `QA_EMAIL`
- `ROOT_EMAIL`
- `SES_SERVER`
- `SES_PORT`
- `SES_USERNAME`
- `SES_PASSWORD`
- `SES_FROM`
- `DEBUG`
- `SENTRY_DSN`

Here is an example of running the image:
```
docker run -it --rm --name arachni -p 8080:5000 -e QA_EMAIL=qa@company.com -e ROOT_EMAIL=root@company.com -e SES_FROM=aws@company.com -e SES_SERVER=email.amazonaws.com -e SES_PORT=587 -e SES_USERNAME=username -e SES_PASSWORD=password -e DEBUG=1 arachni:latest
```

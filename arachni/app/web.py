import os
import celery
import collections
from flask import Flask, request, render_template, redirect, url_for, abort
from raven.contrib.flask import Sentry

from tasks import run_scan


DEBUG = bool(os.environ.get('DEBUG', 0))
SCANNER_PATH = os.environ['SCANNER_PATH']
SCANNER_REPORT_PATH = os.environ['SCANNER_REPORT_PATH']
QA_EMAIL = os.environ['QA_EMAIL']
ROOT_EMAIL = os.environ['ROOT_EMAIL']
SES_FROM = os.environ['SES_FROM']
SES_SERVER = os.environ['SES_SERVER']
SES_PORT = os.environ['SES_PORT']
SES_USERNAME = os.environ['SES_USERNAME']
SES_PASSWORD = os.environ['SES_PASSWORD']

ARGS = collections.OrderedDict([
    ('scope-include-pattern', '--scope-include-pattern'),
    ('scope-include-subdomains', '--scope-include-subdomains'),
    ('scope-exclude-pattern', '--scope-exclude-pattern'),
    ('scope-exclude-content-pattern', '--scope-exclude-content-pattern'),
    ('scope-exclude-binaries', '--scope-exclude-binaries'),
    ('scope-redundant-path-pattern', '--scope-redundant-path-pattern'),
    ('scope-auto-redundant', '--scope-auto-redundant'),
    ('scope-directory-depth-limit', '--scope-directory-depth-limit'),
    ('scope-page-limit', '--scope-page-limit'),
    ('scope-extend-paths', '--scope-extend-paths'),
    ('scope-restrict-paths', '--scope-restrict-paths'),
    ('scope-url-rewrite', '--scope-url-rewrite'),
    ('scope-dom-depth-limit', '--scope-dom-depth-limit'),
    ('scope-dom-event-limit', '--scope-dom-event-limit'),
    ('scope-https-only', '--scope-https-only'),
    ('audit-links', '--audit-links'),
    ('audit-forms', '--audit-forms'),
    ('audit-cookies', '--audit-cookies'),
    ('audit-cookies-extensively', '--audit-cookies-extensively'),
    ('audit-headers', '--audit-headers'),
    ('audit-jsons', '--audit-jsons'),
    ('audit-xmls', '--audit-xmls'),
    ('audit-ui-inputs', '--audit-ui-inputs'),
    ('audit-ui-forms', '--audit-ui-forms'),
    ('audit-parameter-names', '--audit-parameter-names'),
    ('audit-with-extra-parameter', '--audit-with-extra-parameter'),
    ('audit-with-both-methods', '--audit-with-both-methods'),
    ('audit-exclude-vector', '--audit-exclude-vector'),
    ('audit-include-vector', '--audit-include-vector'),
    ('http-user-agent', '--http-user-agent'),
    ('http-request-timeout', '--http-request-timeout'),
    ('http-request-redirect-limit', '--http-request-redirect-limit'),
    ('http-request-header', '--http-request-header'),
    ('http-response-max-size', '--http-response-max-size'),
    ('http-cookie-string', '--http-cookie-string'),
    ('http-authentication-username', '--http-authentication-username'),
    ('http-authentication-password', '--http-authentication-password'),
    ('http-authentication-type', '--http-authentication-type'),
    ('http-ssl-verify-peer', '--http-ssl-verify-peer'),
    ('http-ssl-verify-host', '--http-ssl-verify-host'),
    ('http-ssl-version', '--http-ssl-version'),
    ('input-value', '--input-value'),
    ('input-without-defaults', '--input-without-defaults'),
    ('input-force', '--input-force'),
    ('checks-list', '--checks-list'),
    ('checks', '--checks'),
    ('plugins-list', '--plugins-list'),
    ('plugin', '--plugin'),
    ('platforms-list', '--platforms-list'),
    ('platforms-no-fingerprinting', '--platforms-no-fingerprinting'),
    ('session-check-url', '--session-check-url'),
    ('session-check-pattern', '--session-check-pattern'),
    ('browser-cluster-ignore-images', '--browser-cluster-ignore-images'),
    ('browser-cluster-screen-width', '--browser-cluster-screen-width'),
    ('browser-cluster-screen-height', '--browser-cluster-screen-height'),
    ('timeout', '--timeout'),
    ('timeout-suspend', '--timeout-suspend'),
])

app = Flask(__name__)
sentry = Sentry(app)


@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'GET':
        return render_template('index.html', options=ARGS)

    if 'to' not in request.form or not request.form['to']:
        abort(400)
    elif 'website-url' not in request.form or not request.form['website-url']:
        abort(400)

    email_plugin_args = ['report=txt',
                         'from={}'.format(SES_FROM),
                         'bcc={}'.format(ROOT_EMAIL),
                         'server_address={}'.format(SES_SERVER),
                         'tls=true',
                         'server_port={}'.format(SES_PORT),
                         'username={}'.format(SES_USERNAME),
                         'password={}'.format(SES_PASSWORD)]

    url = None
    options = []
    for k, v in request.form.iteritems():
        if k == 'qa':
            email_plugin_args.append('cc={}'.format(QA_EMAIL))
        elif k == 'to':
            email_plugin_args.append('to={}'.format(v))
        elif k == 'website-url':
            url = v
        elif k in ARGS:
            # XXX: since we're using raw user input in shell command
            # there is a potential for injecting malicious commands
            # but since the app is for internal use only the threat
            # is negligible
            options.append('{}={}'.format(ARGS[k], v))

    email_plugin_args = ','.join(email_plugin_args)

    args = [
        SCANNER_PATH,
        url,
        '--report-save-path={}'.format(SCANNER_REPORT_PATH),
        '--output-only-positives',
        '--plugin="email_notify:{}"'.format(email_plugin_args)] + options

    task_id = run_scan.delay(args, 'artiom')
    return redirect(url_for('status', task_id=task_id))


@app.route('/status/<task_id>', methods=['GET'])
def status(task_id):
    result = run_scan.AsyncResult(task_id)
    status = result.status
    if status in celery.states.EXCEPTION_STATES:
        return render_template('task_failure.html', status=status)
    elif status in celery.states.READY_STATES:
        return result.get()
    else:
        return render_template('task_running.html', status=status, url=request.path)


if __name__ == '__main__':
    app.run(port=int(os.environ['PORT']), debug=DEBUG, host='0.0.0.0')

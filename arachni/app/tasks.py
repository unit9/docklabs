import subprocess
from celery import Celery

celery = Celery('arachni')
celery.config_from_object('celeryconfig')

def call_scanner(args):
    cmd = ' '.join(args)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    stdout, stderr = p.communicate()
    if stdout:
        stdout = stdout.replace('\n', '<br />')
    return stdout, stderr


@celery.task
def run_scan(args, author, notify_qa=False):
    stdout, stderr = call_scanner(args)
    return stdout or stderr

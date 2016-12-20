#!/usr/bin/env python
import json
import logging
import os
import re
import subprocess
import sys
import urlparse
import wsgiref.handlers

import werkzeug
import werkzeug.serving


logging.basicConfig(level=logging.DEBUG)


def getoutput(cmd):
    p = subprocess.Popen(
        cmd,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
    )
    p.stdin.close()
    out = p.stdout.read()
    status = p.wait()
    if status != 0:
        raise RuntimeError(status)
    return out


def response(status=200, headers=None, data=None, message=None):
    if data is None:
        data = {}
    data.setdefault("status", status)
    if message:
        data.setdefault("message", message)
    return werkzeug.wrappers.Response(
        response=json.dumps(data, indent=4, sort_keys=True),
        status=202,
        headers=headers,
        mimetype="application/json"
    )


@werkzeug.wrappers.Request.application
def application(request):
    if request.path != "/":
        return response(404)
    if request.method != "GET":
        return response(405)
    query = dict(urlparse.parse_qsl(request.query_string))
    try:
        container = query["container"]
    except LookupError:
        return response(400, message="required parameter: container")
    try:
        image = getoutput([
            "docker", "inspect", "--type", "container",
            "-f", "{{.Config.Image}}", container,
        ]).strip()
    except RuntimeError as e:
        if e.args[0] == 1:
            return response(404)
        raise
    tags = getoutput([
        "docker", "inspect", "--type", "image",
        "-f", r'{{ range .RepoTags }}{{ printf "%s\n" .}}{{ end }}',
        image,
    ]).strip().split()
    return response(data={"image": image, "tags": tags})


if __name__ == "__main__":
    if os.environ.get("REQUEST_METHOD"):
        wsgiref.handlers.CGIHandler().run(application)
    else:
        werkzeug.serving.run_simple(
            os.environ.get("HOST", "localhost"),
            int(os.environ.get("PORT", "8600")),
            application)

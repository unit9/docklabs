#!/usr/bin/env python
import json
import logging
import os
import re
import subprocess
import sys
import urlparse
import wsgiref.handlers

import flask


app = flask.Flask(__name__)
app.debug = int(os.environ.get("DEBUG", "0"))
app.logger.setLevel(logging.DEBUG)
app.logger.addHandler(logging.StreamHandler())


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


def docker_list_containers():
    lines = getoutput([
        "docker", "ps", "-a",
        "--format", "{{.ID}}\x1f{{.Names}}\x1f{{.Image}}",
    ]).strip().split("\n")
    data = [line.split("\x1f", 2) for line in lines]
    return [{"id": id, "names": names.split(","), "image": image}
                   for id, names, image in data]


def docker_inspect_containers(*containers):
    try:
        return json.loads(getoutput([
            "docker", "inspect", "--type", "container",
        ] + list(containers)))
    except RuntimeError as e:
        if e.args[0] == 1:
            return []
        raise


def docker_inspect_image_tags(image):
    rawtags = getoutput([
        "docker", "inspect", "--type", "image",
        "-f", r'{{ range .RepoTags }}{{ printf "%s\n" .}}{{ end }}',
        image,
    ]).strip().split()
    return [{"repository": repository, "tag": tag}
            for repository, tag in map(lambda s: s.split(":"), rawtags)]


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


@app.route("/")
def index():
    client, server = getoutput([
        "docker", "version",
        "-f", "{{ .Client.Version }} {{ .Server.Version }}",
    ]).strip().split()
    return flask.jsonify(
        message="Hello",
        version=dict(client=client, server=server),
    )


@app.route("/whoami")
def get_whoami():
    ip = flask.request.remote_addr
    containers = docker_list_containers()
    name = None
    image = None
    tags = []
    for container in containers:
        for container in docker_inspect_containers(*container["names"]):
            if container["NetworkSettings"]["IPAddress"] == ip:
                name = container["Name"].lstrip("/")
                image = container["Config"]["Image"]
                tags = docker_inspect_image_tags(image)
                break
    return flask.jsonify(ip=ip, name=name, image=image, tags=tags)


@app.route("/containers")
def list_containers():
    containers = docker_list_containers()
    return flask.jsonify(containers=containers)


@app.route("/containers/<string:container>")
def get_container(container):
    containers = docker_inspect_containers(container)
    if not containers:
        return flask.abort(404)
    image = containers[0]["Config"]["Image"]
    tags = docker_inspect_image_tags(image)
    return flask.jsonify(image=image, tags=tags, name=container)


if __name__ == "__main__":
    if os.environ.get("REQUEST_METHOD"):
        wsgiref.handlers.CGIHandler().run(app.wsgi_app)
    else:
        import werkzeug.serving
        werkzeug.serving.run_simple(
            os.environ.get("HOST", "localhost"),
            int(os.environ.get("PORT", "8600")),
            app.wsgi_app)

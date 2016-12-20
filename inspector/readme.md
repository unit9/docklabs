# Inspector

Inspector exposes a simple API to query running containers' images and
tags.

Build it:

    docker build -t unit9/inspector .

Run it:

    docker run -ti --rm \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -p 8600:8600 --name inspectme inspector

Probe it:

    $ curl localhost:8600?container=inspectme
    {
        "status": 200,
        "image": "unit9/inspector",
        "tags": [
            "unit9/inspector:latest"
        ]
    }

Use with `jq` and `cut`:

    $ curl -s localhost:8600?container=inspectme | jq -r .tags[] \
        | cut -d: -f2
    latest

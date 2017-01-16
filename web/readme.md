# Webapp base images

This is a suite of base images supporting various backend & frontend
dev stacks used at [UNIT9][].

There are several flavors available, which support following runtimes:

- Python 2.7
- Python 3.4
- Node 6
- Node 7

You may also want to read up a bit about [`unit9/base`][unit9-base]
for the low-level stuff.

[unit9-base]: https://github.com/unit9/docklabs/tree/master/base
[UNIT9]: https://www.unit9.com/

## Flavors

The following flavors are available:

- `unit9/web-py27`
- `unit9/web-py34`
- `unit9/web-node6`
- `unit9/web-node7`
- `unit9/web-py27-node6`
- `unit9/web-py27-node7`
- `unit9/web-py34-node6`
- `unit9/web-py34-node7`

## Using

1. Choose some flavor (e.g. `unit9/web-py27-node6`)
2. Drop in a `requirements.txt` file for your Python needs
3. Drop a `package.json` for your Node modules
4. Customize the example `Dockerfile`
5. Build!

## Example `Dockerfile`

    from unit9/web-py27-node6:latest
    maintainer You <you@example.com>

    add requirements.txt /app
    run pip install -r ./requirements.txt

    add package.json /app
    run npm install

    add . /app

## Generating new base Dockerfiles

The Dockerfiles under [/web/images/][] are all **auto-generated**
using a script. You should never edit them directly.

Instead, follow the comments for a section you're interested in to
find the file from which the section is generated.

For example, to edit how Python 2.7 is installed in Dockerfiles for
`web-py27`, `web-py27-node6`, etc. please edit the file
[/web/parts/Dockerfile-py27][].

Then, to re-generate the Dockefiles, run `./web/generate`.

## License

See the file [`LICENSE`][/LICENSE].

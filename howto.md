# Docker at UNIT9 - howto

## Prologue / principles

1. Unless you have a very good reason, always start with
   `unit9/base:latest`.

    - It will be maintained for as long as `debian:jessie` will be
      receiving security updates. It will always be based on Debian
      Jessie; when a new Debian release happens, a new base image will
      be created, so that all the old images at least can still build.

    - Debian's official Docker images are patched/rebuilt less
      frequently than `unit9/base`, and often include
      [vulnerable packages][docker-debian-jessie-security].

    - Our base image runs a `dist-upgrade` on each rebuild, thus
      security fixes appear approximately as soon as they're in
      Debian's repositories.

2. Automate as much as you can.

    - You will NOT feel like coming back here to rebuild and update
      all of your images by hand, every time
      [glibc gets a CVE][glibc-cve].

    - Use [Docker Hub's][dockerhub] automated builds feature, or other
      CI system. At least, ensure your own image is rebuilt every
      time:

        - The `master` branch is updated, and/or
        - `unit9/base` image is updated

3. Document everything.

    - Link to upstream docs.
    - Don't be shy to put inline comments.
    - Explain how your integration with Docker differs from the usual
      / "orthodox" setup.
    - Include examples for configuring and running your image with
      various tools / platforms (like k8s or docker-compose), or how
      to make it play nice with other dockerized apps.

[dockerhub]: https://hub.docker.com/
[docker-debian-jessie-security]: https://hub.docker.com/r/library/debian/tags/jessie/
[glibc-cve]: https://security-tracker.debian.org/tracker/source-package/glibc

## HOWTOs

### Create a new image

1. Copy the `example` directory with all of its structure.

2. Look at each and every file you copied: there are comments with
   `TODO` near every line that needs your action. Most importantly:

    - Inspect the `Makefile`, change the `NAME`.
    - Build the `Dockerfile` to suit your application. Pay attention
      to how the layers are structured, to optimize the use of build
      caches.
    - Use the provided `rc.local` and `*.run` files as examples on how
      to make your package work with the `runit` init system. (Check
      the section "Working with `runit`"!)

3. Run `make build`, `make run`, etc. to make sure your image builds &
   behaves as intended. If ready, you can push a build to Docker Hub
   with `make push`, but better ensure the build is fully automated.

4. Create a pull request against `unit9/docklabs`/`master`!

### Working with `runit`

[`runit`](http://smarden.org/runit/) is an extremely lightweight init
scheme. It was made to run on "classic" Unix hosts, but its overall
architecture made it easy to adapt to running in containers.

#### Perform one-off initialization

- Create and/or override the file `/etc/rc.local`.
- Make sure it's executable (commit it with the `+x` bit in git).
- Make it exit with a >0 status if things go wrong (failed to validate
  config file, etc). This will make the container exit with a failed
  status code, which is easily detected by monitoring in production.

#### Run a service

- Many daemons are designed to fork; read up the manual page to find
  the flag or config file stanza to stop it from forking. For example:

    - `nginx` needs a `-g "daemon off;"` flag, or a `daemon off;`
      directive in its `nginx.conf` file;
    - `anacron` needs a `-d` flag;
    - `transmission-daemon` needs an `-f` flag; etc.

- Create an executable file that follows this general pattern:

        #!/bin/sh
        set -eu
        exec mydaemon --no-fork

- Save it as `mydaemon.run`.

- Add this layer near the bottom of your `Dockerfile`:

        ADD mydaemon.run /etc/service/mydaemon/run

#### Notes

Most important things to note, you will almost certainly **NOT** need
to do any of these:

- Do not set or override `ENTRYPOINT` or `CMD` in your `Dockerfile`;

- Do not fork; do not use pid files - this is already standard
  practice with Docker.

Other important things to note:

- While you can run more than one service per container, remember to
  split things up logically, so the container is concerned with one
  "thing" (e.g. it's OK to run a web server to serve static files, and
  reverse proxy into a FastCGI program, that runs as another service).

- Remember to `exec` at the end of the script, to avoid having a
  lingering shell process between init and your program.

## Create an automated build on Docker Hub

1. Log in to [Docker Hub][dockerhub];
2. Click "create" / "create automated build";
3. Select Github; authorize to read public repos;
4. Select `unit9/docklabs` as source repository; or use other source
   repository if appropriate;
5. Pick namespace and name; namespace should be `unit9` for stuff in
   `unit9/docklabs`; name should be EXACTLY the same as `NAME` in your
   `Makefile` (if using `common.mk`);
6. Add a one-liner description and hit "click here to customize";
7. For each rule, change "Dockerfile location" to a sub-path in the
   repository that includes your stuff; you may also want to change
   wildcard branch builds to wildcard tag builds;
8. Hit "create", go to "build settings";
9. If your image's source is in `unit9/docklabs` and it descends from
   another image in this repository, you will want to *un-check* the
   box next to "builds will happen automatically on pushes", and
   *instead*, go to "repository links" and add dependencies on your
   base image (most usually only `unit9/base`).

Check [this example][dockerhub-example] for a correctly configured
automated build.

[dockerhub-example]: https://hub.docker.com/r/unit9/example/~/settings/automated-builds/

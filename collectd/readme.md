# Collectd daemon with Facette as frontend

This image installs [`collectd`](https://collectd.org/) and
[`facette`](https://facette.io/).

Collectd is compiled from source and installed to `/opt` by default. Only two
plugins are configured during compilation: snmp and rrd.

No configuration provided for collectd in this image. You need to create
your own config file and place it into `/opt/collectd/etc/collectd.conf`.

Facette is installed from the deb file and configured to read data from
`/var/lib/collectd/rrd/<source>/snmp/`.

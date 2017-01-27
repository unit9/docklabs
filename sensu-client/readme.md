# Sensu client

[Sensu][] is a monitoring system that doesn't suck.

[Sensu]: https://sensuapp.org/

This image packages Sensu itself, plus `run` scripts to run the
client.

Any configuration should be injected via the volume
`/etc/sensu/conf.d` or `/etc/sensu/client.json`. Refer to
[Sensu docs][] for details.

[Sensu docs]: https://sensuapp.org/docs/latest/reference/configuration.html

If instead, you wish to generate some simple configuration during
container boot, add a script named `/etc/rc.local.sensu`, which (if
exists) will be run before config validation happens.

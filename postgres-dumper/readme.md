# PostgreSQL DB dumper

This image runs a periodic dump of your PostgreSQL database, using the
`pg_dumpall` utility. It's based on `unit9/cron` and follows the daily
schedule (dumps at 6:25 AM).

It's using the 9.6 version of Postgres tools, as found in Debian
Jessie backports, which should support every version of the server,
[all the way back to 7.0][postgres-docs-upgrade] or so.

[postgres-docs-upgrade]: https://www.postgresql.org/docs/9.6/static/upgrading.html

Backups are stored in `/var/backups`, and are automatically compressed
with `gzip`.

You may want to mount a persistent volume on `/var/backups`.

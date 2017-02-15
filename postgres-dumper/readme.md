# PostgreSQL DB dumper

This image runs a periodic dump of your PostgreSQL database (using the
`pg_dumpall` utility), and (optionally) uploads the dumps to [GCS][].
It's based on `unit9/cron` and follows the daily schedule (dumps at
6:25 AM).

[GCS]: https://cloud.google.com/storage/docs/

It's using the 9.6 version of Postgres tools, as found in Debian
Jessie backports, which should support every version of the server,
[all the way back to 7.0][postgres-docs-upgrade] or so.

[postgres-docs-upgrade]: https://www.postgresql.org/docs/9.6/static/upgrading.html#UPGRADING-VIA-PGDUMPALL

Backups are stored in `/var/backups`, and are automatically compressed
with `gzip`.

if `GS_PATH` is not empty, the GCS upload job will start after the
backup job has finished, and will remove each file after successful
upload.

If you're not using the included GCS integration, you may want to
mount a persistent volume on `/var/backups` and/or handle offsite
backups some other way.

## Variables

Defaults are as follows:

- `PGUSER`: `postgres`
- `PGPASSWORD`: `postgres`
- `PGHOST`: `postgres`
- `PGPORT`: `5432`
- `BOTO_PATH`: empty
- `GS_PATH`: empty

Everything `PG*` behaves exactly as described in
[Postgres docs][postgres-docs-env].

[postgres-docs-env]: https://www.postgresql.org/docs/9.6/static/libpq-envars.html

If you want to use the GCS integration, you will have to:

1. Provide the credentials - e.g. by mounting `/etc/boto.cfg`
   ([or set `BOTO_PATH`][boto-path]), or using an instance service
   account on GCE

2. Set `GS_PATH`, e.g. `gs://my-test-bucket/backups/`

[boto-path]: https://cloud.google.com/storage/docs/gsutil/commands/config#configuration-file-selection-procedure

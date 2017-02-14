# Run things periodically via cron

This image runs the [`cron(8)`][cron-8] daemon.

Drop your executable scripts in any of the usual `/etc/cron.*/*`
directories (which are wiped off all the standard Debian stuff on
build). You should probably do so by extending this image with your
custom code / services.

## Running your code

Supported directories / schedules are:

- `/etc/cron.hourly` - Every hour at 17th minute
- `/etc/cron.daily` - Every 24 hours at 6:25 AM
- `/etc/cron.weekly` - Every Saturday at 6:47 AM
- `/etc/cron.monthly` - Every month on the 1st day, at 6:52 AM

If you need to override this schedule, override the file
[`/etc/crontab`][crontab-5].

If you need a more frequent or more specific schedule, drop a
[`crontab(5)`][crontab-5]-formatted file in `/etc/cron.d/*`.

[cron-8]: https://manpages.debian.org/jessie/cron/cron.8.en.html
[crontab-5]: https://manpages.debian.org/jessie/cron/crontab.5.en.html

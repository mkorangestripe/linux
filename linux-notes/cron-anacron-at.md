# Job Scheduling

#### Cron

```shell script
# minute, hour, day of month, month, day of week
/etc/crontab      # just contains the format for crontab entries
/var/spool/cron/  # current entries for users
/etc/cron.deny    # lists users denied use of crontab, cron.allow takes precedence
/etc/cron.allow   # lists users allowed use of crontab; if blank, allows no users
# If neither cron.deny nor cron.allow exist, only root can use crontab.

# If a job is scheduled by the day of the month,
# an * in the ‘day of week’ column will be irrelevant.

# */5 in the minute column will run command every 5 minutes.
# */2 in the hour column will run command every other hour.
# Sunday can be both 0 or 7.

0 * * * * /home/testuser1/cleanup.sh  # run cleanup.sh hourly

crontab -eu testuer1   # edit the crontab for testuser1
crontab -lu testuser1  # list the crontab entries for testuser1
crontab -ru testuser1  # remove the crontab entries for testuser1
```


#### Anacron

```shell script
# Runs daily, weekly, and monthly jobs if jobs haven’t been run in the last day, week, month.
/etc/cron.d/0hourly        # runs scripts in /etc/cron.hourly, by default just /etc/cron.hourly/0anacron
/etc/cron.hourly/0anacron  # if on ac power & anacron hasn’t run in last 24 hrs, run anacron -s
anacron -s                 # runs entries in /etc/anacrontab
/etc/anacrontab            # contains directories: /etc/cron.daily, /etc/cron.weekly, /etc/cron.monthly
```


#### At

```shell script
# Schedule a job to run once:
at now + 1 hour
at 8:00 tomorrow
at 8:00 aug 11
# Type command to run, Enter, Ctrl+d

atq             # list at queue
/var/spool/at/  # contains jobs in 'at' queue
atrm 12         # remove job 12 from at queue
# The allow and deny files work the same as cron allow and deny.


/etc/motd  # message of the day, displayed at login
wall "Time for a break;  Press Enter to continue"  # send the message to all terminals
```

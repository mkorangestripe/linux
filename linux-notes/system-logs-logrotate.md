# System logs, Logrotate

#### System logs

```shell script
/var/log/messages  # system diagnostic messages from current date
/var/adm/messages  # system diagnostic messages from current date on Solaris
dmesg              # system diagnostic messages on Solaris

dmesg           # kernel ring buffer info, includes lines not yet written to /var/log/dmesg
/var/log/dmesg  # kernel ring buffer info

less +F /var/log/system.log  # follow mode, like tail -f
# Shift + F, Ctrl + C  (Use to enter and exit follow mode)

# Log to the syslog (/var/log/messages) with tag "catalina-logrotate":
logger -t catalina-logrotate "ALERT exited abnormally with [$EXITVALUE]"
```

#### Logrotate

```shell script
/etc/cron.d/0hourly        # includes /etc/cron.hourly/
/etc/cron.hourly/0anacron  # runs /usr/sbin/anacron -s
/etc/anacrontab            # includes /etc/cron.daily/
/etc/cron.daily/logrotate  # runs '/usr/sbin/logrotate /etc/logrotate.conf'
/etc/logrotate.conf        # includes /etc/logrotate.d/
/etc/logrotate.d/          # contains conf files for individual apps

# Status of log rotation.  If zero bytes or too large, logrotate may fail.
/var/lib/logrotate.status

# Force logrotate to run:
logrotate -fv

# Example logrotate stanza:
# This will rotate the logs when the current log file grows to 30M.
# Copy and compress the current log to localhost_access_log.txt.1.gz
# Truncate localhost_access_log.txt.
# Keep 35 rotates logs.

/var/misapp/logs/localhost_access_log.txt {
  missingok
  copytruncate
  size 30M
  rotate 35
  compress
}

# delaycompress delays compression until the next rotation leaving the latest rotated log file uncompressed.
# The application should also continue writing to the same file descriptor
# when the current log is rotated (renamed) but left uncompressed.
```

#### SAR

```shell script
/etc/cron.d/sysstat    # runs the following scripts which output to /var/log/sa/
/usr/lib64/sa/sa1 1 1  # writes every 10 minutes to the daily saDD file
/usr/lib64/sa/sa2 -A   # writes daily reports by processing the binary saDD files into text sarDD files at 23:53

# Create report of all stats from the current daily data file.
# Note, if the machine’s date is not set to local time .e.g. UTC, this might not produce as much data as expected.
sar -A > sar.txt
mpstat  # like sar -A, but with processor statistics from the current minute

sar -q -f /var/log/sa/sa10 > sar.10-ldavg.txt  # create report with load averages from the 10th

# Create report with mem, swap, and net stats from the 21st:
sar -r -n DEV -f /var/log/sa/sa21 > sysstat.txt

sar -B  # report paging statistics

# Report unused memory pages and swap-file disk blocks and page-out and page-in activities on Solaris:
sar -r -g -p

# Create report with mem, swap, and net stats from the 21st, formated for databases:
sadf -d /var/log/sa/sa21 -- -r -n DEV > sysstat.txt

# Create report with all CPU usage from the 21st formatted for databases:
sadf -d /var/log/sa/sa21 -- -u ALL > cpu_report_sadf.txt

# Create report with stats from the 10th between 2am and 3am:
sadf -s 02:00:00 -e 03:00:00 /var/log/sa/sa10 > activity10.txt

# Uses the following config files to manage sa logs, etc:
/etc/init.d/sysstat
/etc/sysconfig/sysstat
/etc/sysconfig/sysstat.ioconf

# Set the daily system activity report to run at 2am:
/etc/cron.d/sysstat
0 2 * * * root /usr/lib64/sa/sa2 -A
```

#### Rsyslog

```shell script
# Server setup:
# udp data from only 192.168.0.11

# /etc/rsyslog.conf (uncomment the following lines for UDP)
$ModLoad imtcp
$InputTCPServerRun 514

/etc/init.d/rsyslog restart

# /etc/sysconfig/iptables and ip6tables (add the following rule)
-A INPUT -m state --state NEW -m udp -p udp -s 192.168.0.11 --dport 514 -j ACCEPT

/etc/init.d/iptables restart

tail -f /var/log/messages  # watch for entries from the client

# Client Setup:
# send udp data, info level, to 192.168.0.12

# /etc/rsyslog.conf  (uncomment the following lines, edit the last line as needed)
$WorkDirectory /var/lib/rsyslog  # where to place spool files
$ActionQueueFileName fwdRule1    # unique name prefix for spool files
$ActionQueueMaxDiskSpace 1g      # 1gb space limit (use as much as possible)
$ActionQueueSaveOnShutdown on    # save messages to disk on shutdown
$ActionQueueType LinkedList      # run asynchronously
$ActionResumeRetryCount -1       # infinite retries if host is down
*.info @192.168.0.12:514         # tcp: @@, udp: @

/etc/init.d/rsyslog restart
```
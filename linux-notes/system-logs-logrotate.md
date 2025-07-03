# System logs, Logrotate

### System logs

```shell script
# System messages:
/var/log/system.log  # macOS
/var/log/syslog      # Ubuntu
/var/log/messages    # Red Hat
/var/adm/messages    # Solaris
dmesg                # Solaris, latest lines in /var/adm/messages*

# Kernel ring buffer messages:
/var/log/dmesg  # messages fom system boot
dmesg -wT       # latest messages, follow output, human readable timestamps

# Follow mode, like tail -f
less +F /var/log/system.log  # Shift+f, Ctrl+c to enter and exit follow mode

# Log to the syslog with tag "catalina-logrotate":
logger -t catalina-logrotate "ALERT exited abnormally with [$EXITVALUE]"
```

### SystemD logging

```shell script
# Stored as binary files in /var/log/journal

journalctl -n 50 -f                             # show last 50 log lines and follow
journalctl -u getTemps.service -S today         # show logs for getTemps.service from today
journalctl -u getTemps.service -S "1 hour ago"  # show logs from last hour for getTemps.service
```

### Logrotate

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
```

```shell script
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

### Sar

```shell script
# Create report of all stats from the current daily data file.
# If the machine’s date is not set to local time .e.g. UTC, this might not produce as much data as expected.
sar -A > sar.txt

sar -q -f /var/log/sa/sa10 > sar.10-ldavg.txt    # create report with load averages from the 10th

sar -r -n DEV -f /var/log/sa/sa21 > sysstat.txt  # create report with mem, swap, and net stats from the 21st

sar -B  # report paging statistics

# Report unused memory pages and swap-file disk blocks and page-out and page-in activities on Solaris:
sar -r -g -p
```

```shell script
# Create report with mem, swap, and net stats from the 21st formatted for databases:
sadf -d /var/log/sa/sa21 -- -r -n DEV > sysstat.txt

# Create report with all CPU usage from the 21st formatted for databases:
sadf -d /var/log/sa/sa21 -- -u ALL > cpu_report_sadf.txt

# Create report with stats from the 10th between 2am and 3am:
sadf -s 02:00:00 -e 03:00:00 /var/log/sa/sa10 > activity10.txt
```

```shell script
/etc/cron.d/sysstat    # runs the following scripts which output to /var/log/sa/
/usr/lib64/sa/sa1 1 1  # writes every 10 minutes to the daily saDD file
/usr/lib64/sa/sa2 -A   # writes daily reports by processing the binary saDD files into text sarDD files

/etc/init.d/sysstat  # uses the following config files to manage sa logs
/etc/sysconfig/sysstat
/etc/sysconfig/sysstat.ioconf
```

### Rsyslog

Server setup
```shell script
# Receive UDP data from 192.168.0.11

/etc/rsyslog.conf  # uncomment the following lines for UDP
$ModLoad imtcp
$InputTCPServerRun 514

/etc/init.d/rsyslog restart

/etc/sysconfig/iptables   # add the following rule
/etc/sysconfig/ip6tables  # add the following rule
-A INPUT -m state --state NEW -m udp -p udp -s 192.168.0.11 --dport 514 -j ACCEPT

/etc/init.d/iptables restart

tail -f /var/log/messages  # watch for entries from the client
```

Client Setup
```shell script
# Send UDP data, info level, to 192.168.0.12

/etc/rsyslog.conf  # uncomment the following lines, edit the last line as needed
$WorkDirectory /var/lib/rsyslog  # where to place spool files
$ActionQueueFileName fwdRule1    # unique name prefix for spool files
$ActionQueueMaxDiskSpace 1g      # 1gb space limit (use as much as possible)
$ActionQueueSaveOnShutdown on    # save messages to disk on shutdown
$ActionQueueType LinkedList      # run asynchronously
$ActionResumeRetryCount -1       # infinite retries if host is down
*.info @192.168.0.12:514         # tcp: @@, udp: @

/etc/init.d/rsyslog restart
```

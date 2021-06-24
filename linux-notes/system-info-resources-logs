#!/bin/bash

cat /etc/*release  # Linux distribution info
lsb_release -d  # Linux distribution info
python -c "import platform; print platform.dist()"  # Linux distribution info
python -c "import platform; print platform.platform()"  # platform, OS version info
cat /proc/version  # Linux version info
uname -a  # system info
uname -r; ls -lt /boot/config*  # compare running kernel to installed kernels
dkms status  # show installed kernels
dmidecode --string system-manufacturer
hostnamectl status  # get hostname and system info
hostnamectl set-hostname server1.domain.com  # set hostname

lsblk  # list block devices
lspci  # list all PCI devices
lsusb  # list usb devices

cat /proc/cpuinfo  # cpu info
lscpu  # cpu info
prtdiag | grep CPU  # cpu info on Solaris
psrinfo  # cpu info on Solaris
isainfo  # instruction set architectures on Solaris

cat /proc/meminfo  # memory info
prtconf | grep Mem  # installed memory on Solaris
free  -m  # memory info in MB
vmstat  # Report virtual memory statistics

top  # realtime display of load, cpu, mem, and swap usag# 
top -n 1 -b  # 1 iteration, batch mode, useful for outputting to other program# 
prstat -Z  # realtime display of process statistics including zones - Solari# 

ps aux  # all processes, %CPU, %MEM
ps eux  # all processes, %CPU, %MEM, environment variables

# STIME column shows time if process was started on current day and date if started on a previous day.
# TIME column shows cumulated CPU time.
ps -ef  # all processes, full path, STIME, etc
ps -el  # all processes, full path, nice number, state code, etc
ps -elf  # all processes, full path, STIME, nice number, state code, etc
ps -el | awk '$2 != "S"'  # process state codes other than S, interruptible Sleep
ps -eo pid,user,lstart,args  # STARTED column shows full process start time and date, -Ao also works

ps -fu <username>  # processes with info for the given user
pstree  # tree view of processes

# Zombie processes are processes that have completed execution, but still have an entry in the process table.
# This entry is needed for the parent process (ppid) to read the child process’s exit status.
# The following commands search for zombie processes (Z in process state code field).
ps aux | awk '{print $8,$2}' | grep '^Z'
ps -el | awk '$2 == "Z"'
ps -eo s,pid,ppid | grep '^Z'

# Try the following to kill a zombie process or just kill the ppid.
kill -s SIGCHLD ppid

# Nicenesses range: -20 (most favorable scheduling), 19 (least favorable), 10 (default adjustment)
nice -n 19 python prime_gen.py
renice <n> <pid>
kill <-9> <pid>
pkill httpd
pkill -9 -f '(test1|test2)'
killall httpd

dstat  # scrolling cpu usage, disk r/w, net send/recv, paging i/o, and system int/csw
iostat  # cpu and I/O stats for devices

nfsstat -o all  # list nfs statistics
nfsiostat  # iostat for NFS mounts

/proc  # includes a directory for each running process
/proc/PID/cmdline  # contains the command that originally started the process
/proc/PID/cwd  # a symlink to the current working directory of the process
/proc/PID/environ  # contains names and contents of environment variables affecting the process
/proc/PID/exe  # a symlink to the original executable file
/proc/PID/fd  # contains symlinks for each open file descriptor

/var/run  # includes PID files of services

lsof  # list open files
lsof /var/log/messages  # list everything interacting with the given directory
fuser -v -u /cluster/cpg  # list PIDs and users interacting with the given directory
lsof -p 19881  # list open files used by this PID
lsof -i :80  # list processes using port 80
fuser -v -n tcp 80  # list processes using port 80

# Open file descriptor count for cassandra excluding mem type fd's - from lsof:
lsof -np $(ps -u cassandra -o pid --no-headers | head -1) | sed '1d' | grep -v mem | wc -l

# Open file descriptor count for cassandra - from proc:
ls /proc/$(ps -u cassandra -o pid --no-headers | head -1 | sed 's/^[ \t]*//')/fd | wc -l

ulimit -n  # file descriptor limit

time ./ps1a.py  # times the execution of the script ps1a.py
# The -- is necessary on some systems to prevent the timeout command from evaluating the arguments of the subsequent command:
timeout -t 600 -- ls -lh  # timeout after 600 seconds

strace  ls  # trace system calls and signals made by the ls command
# Trace system calls on Solaris for a given pid, also check if zone process exists on global:
truss -p PID
valgrind  # a suite of tools for debugging and profiling programs

grep Kill /var/log/messages  # find info about killed processes

# Find processes killed by being out of memory:
grep "Out of memory" /var/log/messages
zgrep "Out of memory" /var/log.archive/messages*
# Lines like the following will exist:
# Jul  8 04:36:47 gcutlcte004 kernel: Out of memory: Kill process 2125 (java) score 303 or sacrifice child

# To exclude the process from the OOM killer:
echo -17 > /proc/PID/oom_adj

# A range of -16 to 15 is from less likely to most likely to be killed by the OOM.
# -17 exempts the process entirely from the OOM killer but could result in important operating system processes being killed.
# Also see /proc/PID/oom_score and /proc/PID/oom_score_adj.

# Load averages for the last 1, 5, and 15 minutes:
uptime
cat /proc/loadavg
w | head -1

# CPU queue lengths can directly reflect the amount of load on a CPU.
# Load average of "1.73 0.60 7.98" on a single-CPU system:
# During the last minute, the system was overloaded by 73% on average (1.73 runnable processes, so that 0.73 processes had to wait for a turn for a single CPU system on average).
# During the last 5 minutes, the CPU was idling 40% of the time on average.
# During the last 15 minutes, the system was overloaded 698% on average (7.98 runnable processes, so that 6.98 processes had to wait for a turn for a single CPU system on average).

/etc/cron.d/sysstat  # runs the following scripts which output to /var/log/sa/
/usr/lib64/sa/sa1 1 1  # writes every 10 minutes to the daily saDD file
/usr/lib64/sa/sa2 -A  # writes daily reports by processing the binary saDD files into text sarDD files at 23:53

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

/etc/init.d/sysstat  # uses the following config files to manage sa logs, etc
/etc/sysconfig/sysstat
/etc/sysconfig/sysstat.ioconf

# Set the daily system activity report to run at 2am:
/etc/cron.d/sysstat
0 2 * * * root /usr/lib64/sa/sa2 -A

/var/log/messages  # system diagnostic messages from current date
/var/adm/messages  # system diagnostic messages from current date on Solaris
dmesg  # system diagnostic messages on Solaris

dmesg  # kernel ring buffer info, includes lines not yet written to /var/log/dmesg
/var/log/dmesg  # kernel ring buffer info

less +F /var/log/system.log  # follow mode, like tail -f
# Shift + F, Ctrl + C  (Use to enter and exit follow mode)

# Log to the syslog (/var/log/messages) with tag "catalina-logrotate":
logger -t catalina-logrotate "ALERT exited abnormally with [$EXITVALUE]"

# Memory page:
# A fixed-length contiguous block of virtual memory, 
# the smallest unit of data for memory allocation and 
# the transfer between main memory and any other auxiliary store.

# Logrotate:
# /etc/cron.d/0hourly includes /etc/cron.hourly/
# /etc/cron.hourly/0anacron runs /usr/sbin/anacron -s
# /etc/anacrontab includes /etc/cron.daily/
# /etc/cron.daily/logrotate runs (/usr/sbin/logrotate /etc/logrotate.conf)
# /etc/logrotate.conf includes /etc/logrotate.d/
# /etc/logrotate.d/ contains conf files for individual apps.

# Status of log rotation.  If zero bytes or too large, logrotate may fail.
/var/lib/logrotate.status

# Force logrotate to run:
logrotate -fv

# Example logroate stanza:
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


# Remote system logging - server setup - udp data from only 192.168.0.11
# ------------------------------
# /etc/rsyslog.conf (uncomment the following lines for UDP)
$ModLoad imtcp
$InputTCPServerRun 514

/etc/init.d/rsyslog restart

# /etc/sysconfig/iptables and ip6tables (add the following rule)
-A INPUT -m state --state NEW -m udp -p udp -s 192.168.0.11 --dport 514 -j ACCEPT

/etc/init.d/iptables restart

tail -f /var/log/messages  # watch for entries from the client

# Remote system logging - Client Setup - send udp data, info level, to 192.168.0.12
# ------------------------------
# /etc/rsyslog.conf  (uncomment the following lines, edit the last line as needed)
$WorkDirectory /var/lib/rsyslog # where to place spool files
$ActionQueueFileName fwdRule1 # unique name prefix for spool files
$ActionQueueMaxDiskSpace 1g   # 1gb space limit (use as much as possible)
$ActionQueueSaveOnShutdown on # save messages to disk on shutdown
$ActionQueueType LinkedList   # run asynchronously
$ActionResumeRetryCount -1    # infinite retries if host is down
*.info @192.168.0.12:514    # tcp: @@, udp: @

/etc/init.d/rsyslog restart


# NTP server setup:
# ------------------------------
# /etc/ntp.conf (something like the following)
restrict default kod nomodify notrap  # remove nopeer
restrict 192.168.0.0 mask 255.255.255.0 notrap nomodify  # allow ntp clients access
# Uncomment the existing or add server lines.

# Open UDP port 123

# NTP Client setup:
# ------------------------------
# /etc/ntp.conf:
server 192.168.0.12

service ntpd restart

# Another option:
service ntpd stop; chkconfig ntpd off
# /etc/ntp/step-tickers  (add the ip or hostname of the ntp server)
service ntpdate start; chkconfig ntpdate on

ntpq -p localhost  # test NTP servers in /etc/ntp.conf
ntpq -p <remote ip addr>  # test remote ntp server


# Set local time to Central:
unlink /etc/localtime
ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime

cal -3 # three month
cal -y # current year
cal 2012 # 2012 calendar

# Shows when the current yearly calendar repeats.
# Non-leap year cycle: 6,11,11 years.
# Leap year cycle: 28 (6+11+11) years.
for YEAR in {1970..2070}; do diff -q <(cal -y | tail -34) <(cal $YEAR | tail -34) && echo $YEAR; done

date -u  # print date in UTC
date -d @1299287329  # converts Unix time to readable output
date "+%F %T"  # year-month-day hour:minute:second
date --date='2 days ago' '+%Y%m%d'  # two days ago in YYYYMMDD


# Solaris Zones
cat /etc/zone_parent  # show global zone on Solaris
ls /etc/zones/  # list zones on global
zoneadm list -cv  # list configured zones on Solaris with status
zoneadm -z <zone> boot
zoneadm -z <zone> reboot
zoneadm -z <zone> shutdown
zoneadm -z <zone> halt
zlogin <zone>  # login to zone

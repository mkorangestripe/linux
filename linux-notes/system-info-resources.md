# System info, resources

### System info

```shell script
cat /etc/*release  # Linux distro
lsb_release -d     # Linux distro

python -c "import platform; print(platform.dist())"      # Linux distro
python -c "import platform; print(platform.platform())"  # platform, OS, kernel

uname -a           # platform, OS, kernel
cat /proc/version  # Linux kernel version
uname -r; ls -lt /boot/config*  # compare running kernel to installed kernels
dkms status        # show installed kernels

dmidecode -t system
dmidecode --string system-manufacturer

hostnamectl status                           # get hostname and system info
hostnamectl set-hostname server1.domain.com  # set hostname

lsblk  # list block devices
lspci  # list all PCI devices
lsusb  # list usb devices

cat /proc/cpuinfo   # cpu info
lscpu               # cpu info
prtdiag | grep CPU  # cpu info on Solaris
psrinfo             # cpu info on Solaris
isainfo             # instruction set architectures on Solaris
```

### Processes, Memory

```shell script
cat /proc/meminfo   # memory info
prtconf | grep Mem  # installed memory on Solaris
free  -m            # memory info in MB
vmstat              # virtual memory statistics

mpstat  # processor statistics

top          # realtime display of load, cpu, mem, and swap usage, press z for color output
top -n 1 -b  # 1 iteration, batch mode, useful for outputting to other programs
prstat -Z    # realtime display of process statistics including zones on Solaris

ps aux  # all processes, %CPU, %MEM
ps eux  # all processes, %CPU, %MEM, environment variables

# STIME column shows time if process was started on current day and date if started on a previous day.
# TIME column shows cumulated CPU time.
ps -ef   # all processes, full path, STIME, etc
ps -el   # all processes, full path, nice number, state code, etc
ps -elf  # all processes, full path, STIME, nice number, state code, etc
ps -el | awk '$2 != "S"'     # process state codes other than S, interruptible Sleep
ps -eo pid,user,lstart,args  # STARTED column shows full process start time and date, -Ao also works

ps -fu user1  # processes owned by user1
pstree        # tree view of processes
```

##### Zombie processes
```shell script
# Zombie processes are processes that have completed execution, but still have an entry in the process table.
# This entry is needed for the parent process (ppid) to read the child process’s exit status.
# The following commands output zombie processes (Z in process state code field).
ps aux | awk '{print $8,$2}' | grep '^Z'
ps -el | awk '$2 == "Z"'
ps -eo s,pid,ppid | grep '^Z'

# Kill zombie processes under the parent pid:
kill -s SIGCHLD <ppid>
```

##### Nice, kill
```shell script
# Nicenesses range: -20 (most favorable scheduling), 19 (least favorable), 10 (default adjustment)
nice -n 19 python prime_gen.py
renice <n> <pid>
kill <-9> <pid>
pkill httpd
pkill -9 -f '(test1|test2)'
killall httpd
```

##### Files, devices, proc filesystem
```shell script
dstat   # scrolling cpu usage, disk r/w, net send/recv, paging i/o, and system int/csw
iostat  # cpu and I/O stats for devices

nfsstat -o all  # list nfs statistics
nfsiostat       # iostat for NFS mounts

/proc              # includes a directory for each running process
/proc/PID/cmdline  # contains the command that originally started the process
/proc/PID/cwd      # a symlink to the current working directory of the process
/proc/PID/environ  # contains names and contents of environment variables affecting the process
/proc/PID/exe      # a symlink to the original executable file
/proc/PID/fd       # contains symlinks for each open file descriptor

/var/run  # includes PID files of services

lsof                      # list open files
lsof /var/log/messages    # list everything interacting with the given directory
fuser -v -u /cluster/cpg  # list PIDs and users interacting with the given directory
lsof -p 19881             # list open files used by this PID
lsof -i :80               # list processes using port 80
fuser -v -n tcp 80        # list processes using port 80

# Open file descriptor count for cassandra excluding mem type fd's - from lsof:
lsof -np $(ps -u cassandra -o pid --no-headers | head -1) | sed '1d' | grep -v mem | wc -l

# Open file descriptor count for cassandra - from proc:
ls /proc/$(ps -u cassandra -o pid --no-headers | head -1 | sed 's/^[ \t]*//')/fd | wc -l

ulimit -n  # file descriptor limit
```

##### Testing, debugging
```shell script
time ./ps1a.py            # times the execution of the script ps1a.py
# The -- is necessary on some systems to prevent the timeout command
# from evaluating the arguments of the subsequent command:
timeout -t 600 -- ls -lh  # timeout after 600 seconds

strace  ls  # trace system calls and signals made by the ls command
# Trace system calls on Solaris for a given pid, also check if zone process exists on global:
truss -p PID
valgrind    # a suite of tools for debugging and profiling programs

grep Kill /var/log/messages  # find info about killed processes

# Find processes killed by being out of memory:
grep "Out of memory" /var/log/messages
zgrep "Out of memory" /var/log.archive/messages*
# Lines like the following will exist:
# Jul  8 04:36:47 gcutlcte004 kernel: Out of memory: Kill process 2125 (java) score 303 or sacrifice child

# To exclude the process from the OOM killer:
echo -17 > /proc/PID/oom_adj

# A range of -16 to 15 is from less likely to most likely to be killed by the OOM.
# -17 exempts the process entirely from the OOM killer but could
# result in important operating system processes being killed.
# Also see /proc/PID/oom_score and /proc/PID/oom_score_adj.

# Load averages for the last 1, 5, and 15 minutes:
uptime
cat /proc/loadavg
w | head -1

# CPU queue lengths can directly reflect the amount of load on a CPU.
# Load average of "1.73 0.60 7.98" on a single-CPU system:
# During the last minute, the system was overloaded by 73% on average (1.73 runnable processes,
# so that 0.73 processes had to wait for a turn for a single CPU system on average).
# During the last 5 minutes, the CPU was idling 40% of the time on average.
# During the last 15 minutes, the system was overloaded 698% on average (7.98 runnable processes,
# so that 6.98 processes had to wait for a turn for a single CPU system on average).

# Memory page:
# A fixed-length contiguous block of virtual memory, 
# the smallest unit of data for memory allocation and 
# the transfer between main memory and any other auxiliary store.
```

##### SNMP, Memcached
```shell script
# SNMP, get proc and mem info:
snmpwalk -c <public> -v 2c 192.168.1.112 proc
snmpwalk -c <public> -v 2c 192.168.1.112 mem

# Get memcached stats on memcached server:
echo stats | nc server1 11211
```

### Date

```shell script
# Set local time to Central:
unlink /etc/localtime
ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime

cal -3   # three month
cal -y   # current year
cal 2012 # 2012 calendar

# Shows when the current calendar year repeats.
# Non-leap year cycle: 6,11,11 years.
# Leap year cycle: 28 (6+11+11) years.
for YEAR in {1970..2070}; do diff -q <(cal -y | tail -34) <(cal $YEAR | tail -34) && echo $YEAR; done

date -u              # print date in UTC
date -d @1299287329  # converts Unix time to readable output
date "+%F %T"        # year-month-day hour:minute:second
date --date='2 days ago' '+%Y%m%d'  # two days ago in YYYYMMDD
```

### Solaris Zones

```shell script
cat /etc/zone_parent  # show global zone on Solaris
ls /etc/zones/        # list zones on global

zoneadm list -cv  # list configured zones on Solaris with status
zoneadm -z <zone> boot
zoneadm -z <zone> reboot
zoneadm -z <zone> shutdown
zoneadm -z <zone> halt

zlogin <zone>  # login to zone
```

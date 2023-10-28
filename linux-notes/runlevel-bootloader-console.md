# Runlevel, Bootloader, Console

### Runlevels

**Nonstandard runlevels on RHEL 6**  
From the kernel line in the grub menu delete rhgb quiet (if desired), and append one of the following.  

```
init=/bin/sh
/ is mounted (ro) although mount reports (rw)
only /, /proc, and /sys are mounted

emergency
/ is mounted (ro) although mount reports (rw)
only /, /proc, and /sys are mounted
init is running

single, s, or S
/ is mounted (rw)
local filesystems mounted
init is running
runs everything but scripts in /etc/rc1.d ???
```

**Standard runlevels on RHEL 6**  
See /etc/inittab

```
0 - halt (Do NOT set initdefault to this)
1 - Single user mode
2 - Multiuser, without NFS
3 - Full multiuser mode
4 - unused
5 - X11
6 - reboot (Do NOT set initdefault to this)
```

```shell script
runlevel  # previous, current runlevel
who -r    # current runlevel
```

### Boot process

1) BIOS loads grub
1) grub loads the linux kernel
1) Linux kernel calls the init process
1) init process runs /etc/rc.d/rc.sysinit

```shell script
# rc files on RHEL 6
/etc/init/rcS.conf    # exec /etc/rc.d/rc.sysinit
/etc/rc.d/rc.sysinit  # sets the environment path, starts swap, checks the file systems, etc
/etc/init/rc.conf     # exec /etc/rc.d/rc $RUNLEVEL
/etc/rc.d/rc          # executes scripts in runlevel, /etc/rc.d/rc[0-6].d/

# rc, short for runcom, run command

/etc/init/prefdm.conf  # persistently start/stop the GUI on a specific runlevel
startx                 # starts the GUI
```

### Services

```shell script
# Service on systems using SysV init (using httpd for example):
service --status-all
service httpd start
service httpd stop
service httpd restart
service httpd reload
service sshd status

# Enable/disable services per runlevel on systems using SysV init:
chkconfig --list postfix
chkconfig postfix on
chkconfig --level 4 postfix off  # moves /etc/rc.d/rc4.d/S80postfix to K30postfix
# Links beginning with "K" are stopped when the system leaves the given runlevel.
# Links beginning with "S" are started when the system enters the given runlevel.

ntsysv --level 345  # config services for runlevels 3,4,and 5
```

```shell script
# Services on systems using systemd (using sshd for examples)
systemctl --all
systemctl start sshd
systemctl stop sshd
systemctl restart sshd
systemctl reload sshd
systemctl reload-or-restart sshd
systemctl status sshd
systemctl enable sshd
systemctl disable sshd

systemctl daemon-reload  # reload changed unit file

/etc/systemd/  # systemd info
```

```shell script
# Services on Solaris:
svcs -a                 # show status of all services on Solaris
svcs -v ssh             # show verbose status of ssh, -l for all available info
svcs -x http            # show explanations for service state
svcadm enable -t http   # enable and start http
svcadm restart ssh      # restart ssh
svcadm refresh ssh      # reload ssh config
svcadm disable -t http  # disable and stop http
svcadm clear http       # clear http from maintenance state
/var/svc/log/           # service logs
```

```shell script
# List services on macOS:
sudo launchctl list
```

### Shutdown, Reboot

```shell script
shutdown -r 10 “message”  # reboot in 10 minutes with message
shutdown -h now           # halt or poweroff after bringing down system
shutdown -y -i5 -g0       # yes, init 5, grace period 0s - halt or poweroff on Solaris
shutdown -H now           # halts the system after being brought down
shutdown -P now           # powers off the system after being brought down
shutdown -c               # cancel a running shutdown
shutdown -k now           # send warning msg, disable logins, do not shutdown

# Symlinks for various commands:
/usr/sbin/reboot   -> /bin/systemctl
/usr/sbin/halt     -> /bin/systemctl
/usr/sbin/poweroff -> /bin/systemctl
/usr/sbin/shutdown -> /bin/systemctl
/usr/sbin/telinit  -> /bin/systemctl
/usr/sbin/init     -> /lib/systemd/systemd
```

### Grub bootloader

```shell script
grub-md5-crypt                     # create an md5 password
password --md5 <password-hash>     # place after ‘timeout’ or a title line in  grub.conf

# From the grub prompt at system start:
grub> root                         # identify partition with boot directory
grub> find /grub/grub.conf         # identify partition with boot directory
grub> find (hd0,0)/grub/grub.conf  # identify Linux partitions
grub> cat (hd0,0)/grub/grub.conf   # print grub.conf
grub> cat (hd0,1)/etc/fstab        # print fstab, does not work with logical volumes

# Boot system from grub prompt:
# Use tab to autocomplete and list file names.
grub> root (hd0,0)  # necessary if MBR was modified
grub> kernel /vmlinuz-2.6.32-71.el6.x86_64 ro root=/dev/dm-0
grub> initrd /initramfs-2.6.32-71.el6.x86_64.img
grub> boot

# Reinstalling the Boot Loader:
# Choose Rescue installed system from the menu or try the following:
# Type linux rescue at the installation boot prompt to enter the rescue environment.
chroot /mnt/sysimage         # mount the root partition
/sbin/grub-install /dev/sda  # reinstall the GRUB boot loader
/boot/grub/grub.conf         # review changes
```

### XSCF
eXtended System Control Facility

```shell script
showdomainstatus -a  # show status of all domains
showlogs power       # display log of resets, poweron/off
showstatus           # Lists degraded components
fmdump -v            # view fault management logs, verbose
reset -d 0           # Domain 0 reset
reset -d 0 por       # Domain 0 system reset
reset -d 0 xir       # Domain 0 CPU reset
poweroff -d 0        # poweroff domain 0
poweron -d 0         # poweron domain 0
console -yd 0        # connect to domain 0 console
printenv             # from the OK prompt, check whether auto-boot is enabled
boot                 # from the OK prompt on the console, boot the OS
#. (pound+period, return to XSCF shell)
```

### iLO / ILOM
Integrated Lights Out Management
```shell script
# Reboot examples:

# /SP is the service processor, /SYS is the server itself
show
cd /SP
reset

# /system1 is the system, /map1 is the ilo
show
cd /map1
reset
```

### Automated installation using a kickstart file

```shell script
# Kickstart from an FTP Server:
cp anaconda-ks.cfg ks.cfg
system-config-kickstart ks.cfg  # or edit ks.cfg with vi
# Hostname is set in the network directive with --hostname=tester1
cp ks.cfg /var/ftp/pub/ks.cfg
chmod -c +r /var/ftp/pub/ks.cfg
iptables -F  # or verify that port 21 is open
# Boot from CD, highlight Install or upgrade..., press tab, use the ftp line below:

vmlinuz initrd=initrd.img ks=hd:sdb1:/ks.cfg
vmlinuz initrd=initrd.img ks=cdrom:/ks.cfg
vmlinuz initrd=initrd.img ks=hd:fd0:/ks.cfg
vmlinuz initrd=initrd.img ks=nfs:192.168.122.1/ks.cfg
vmlinuz initrd=initrd.img ks=ftp://192.168.122.1/pub/ks.cfg
vmlinuz initrd=initrd.img ks=http://192.168.122.1/pub/ks.cfg
```

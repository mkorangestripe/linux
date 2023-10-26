# Networking configuration

```shell script
# Enable/disable networking:
/etc/sysconfig/network:
NETWORKING=yes
HOSTNAME=server1

/etc/init.d/network status  # status of network service
/etc/init.d/NetworkManager  # controls eth0 if NM_CONTROLLED="yes" in ifcfg-eth0

# Networkmanager info:
nmcli device show
nmcli connection show
```

```shell script
# Arp displays a table of IP addresses or hostnames with HW addresses.
# This can be helpful in identifying duplicate HW addresses.

cat /proc/net/arp  # print IP addresses and HW addresses

arp -n          # show IP addresses instead of hostnames
arp -s testbox 00:00:00:00:00:00  # set HWaddress of testbox
arp -d testbox  # delete HWaddress of testbox from table
```

```shell script
ifconfig -a              # show all network interfaces active and inactive
ip addr                  # show ip addresses assigned to all network interfaces

ifconfig eth0 <up down>  # enable/disable eth0

# Assign an IP address:
ifconfig eth0 192.168.1.102 netmask 255.255.255.0 broadcast 192.168.1.255
```

```shell script
route     # show ip routing table
route -n  # show ip routing table, do not resolve dns
ip route  # show ip routing table

# Add routes:
route add default gw XXX.XXX.XXX.XXX eth0
route add -net 10.0.3.0 netmask 255.255.255.0 gw 192.168.1.112

# Set a persistent route to 10.0.3.0.  With the NetworkManager
# daemon running the changes will take effect immediately.
/etc/sysconfig/network-scripts/route-eth0:
ADDRESS0=10.0.3.0
NETMASK0=255.255.255.0
GATEWAY0=192.168.1.112
```

```shell script
# Calls scripts and config files in /etc/sysconfig/network-scripts:
ifup ifcfg-eth0    # enable eth0
ifup eth0          # enable eth0
ifdown eth0        # disable eth0
ifdown ifcfg-eth0  # disable eth0

# Assign or request dhcp configuration:
dhclient eth0

# Set a static IP address, several other options exist and might be necessary.
/etc/sysconfig/network-scripts/ifcfg-eth0:
DEVICE=eth0
IPADDR=192.168.122.50
NETMASK=255.255.255.0
GATEWAY=192.168.122.1
DNS1=192.168.122.1

# Shows assignment of network adapter name to network adapter HWaddr.
# If removed, this file is regenerated upon reboot.
# Keep this file in mind when cloning machines.
/etc/udev/rules.d/70-persistent-net.rules
```

#### NSS

```shell script
# Name Service Switch, sources for common configuration databases.
/etc/nsswitch.conf:
hosts: files dns  # this line means /etc/hosts is searched first, dns second

getent hosts dc3install01.c030  # get entry based on hosts line in /etc/nsswitch.conf
service nscd status             # status of Name Service Cache Daemon

/etc/hosts:
127.0.0.1		localhost
74.125.47.100	google.com

/etc/resolv.conf:
nameserver		8.8.8.8
```

#### TCP Wrappers

```shell script
# Check if a service uses TCP Wrappers:
for FILE in /sbin/*; do strings $FILE | grep -q hosts_access && echo $FILE; done
for FILE in /usr/sbin/*; do strings $FILE | grep -q hosts_access && echo $FILE; done

# Confirm that sshd is linked to the TCP Wrapper library:
ldd /usr/sbin/sshd | grep libwrap

# TCP Wrapper process:
# 1) /etc/hosts.allow is searched, if a match is found access is granted, no additional search.
# 2) /etc/hosts.deny is searched, if a match is found, access is denied, no additional search.
# 3) If a match isn’t found in either file, access is automatically granted.

/etc/hosts.allow:
vsftpd, sshd : 192.168.1.111     # allow services vsftp and ssh to 192.168.1.111

/etc/hosts.deny:
ALL : 192.168.                   # deny all services to the 192.168 subnet
sshd : ALL EXCEPT 192.168.110.1  # deny ssh to all except 192.168.110.1

# Limit ssh access to only mike from 192.168.0.11:
/etc/ssh/sshd_config:
PermitRootLogin no
AllowUsers mike@192.168.0.11
/etc/init.d/sshd reload

# Disable X11 forwarding over ssh:
/etc/ssh/sshd_config:
#X11Forwarding yes
```

# Kernel runtime parameters

### Packet forwarding

```shell script
# Enable packet forwarding (non-persistent):
echo 1 > /proc/sys/net/ipv4/ip_forward
/etc/sysctl.conf  # net.ipv4.ip_forward = 1

# Enable packet forwarding using sysctl (persistent):
sysctl -w net.ipv4.ip_forward=1  # sets ip_forward to 1
sysctl net.ipv4.ip_forward  # shows current ip_forward value
```

### ICMP, ping
```shell script
# Drop icmp echo requests (pings), results in “Request timed out”:
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
/etc/sysctl.conf  # icmp_echo_ignore_all = 1

# Return icmp echo broadcast requests:
echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
/etc/sysctl.conf  # icmp_echo_ignore_all = 0
```

### Connection tracking

```shell script
# Enable Connection Tracking, either of the following:
echo 1 > /proc/sys/net/netfilter/nf_conntrack_acct
sysctl -w net.netfilter.nf_conntrack_acct=1

# Adjust size of tracking table (nf_conntrack_max should be nf_conntrack_buckets x 4):
echo 131072 > /proc/sys/net/netfilter/nf_conntrack_max
echo 32768 > /sys/module/nf_conntrack/parameters/hashsize

# Set values persistently in /etc/sysctl.conf:
net.netfilter.nf_conntrack_acct=1
net.netfilter.nf_conntrack_max=131072

# Set the hashsize persistently in /etc/rc.d/rc.local:
echo 32768 > /sys/module/nf_conntrack/parameters/hashsize

# Show the current used connections, either of the following:
cat /proc/sys/net/netfilter/nf_conntrack_count
sysctl net.netfilter.nf_conntrack_count
```

```shell script
sysctl -p  # reread sysctl.conf, use after manually editing a file
```
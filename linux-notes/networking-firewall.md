# Networking firewall

#### iptables

```shell script
iptables -L  # list rules
iptables -S  # print rules
iptables -F  # flush rules

/etc/init.d/iptables status   # similar output as iptables -L
/etc/init.d/iptables restart  # restart and put rules into effect

/etc/sysconfig/iptables     # contains firewall rules
system-config-firewall-tui  # text-based UI for setting firewall rules
```

```shell script
# Reject all network traffic from the specified network:
iptables -A INPUT -s 192.168.110.0/24 -j REJECT

# Delete the reject rule:
iptables -D INPUT -s 192.168.110.0/24 -j REJECT

# Drop icmp echo requests (pings).  Results in “Request timed out”
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Reject icmp echo requests (pings). Results in “Destination port unreachable”
iptables -A INPUT -p icmp --icmp-type echo-request -j REJECT

# Reject icmp echo requests (pings).  Results in “Destination host unreachable”
iptables -A INPUT -p icmp --icmp-type echo-request -j REJECT --reject-with icmp-host-prohibited

# Drop icmp echo replies:
iptables -A INPUT -p icmp --icmp-type echo-reply -j DROP

# Stop packet forwarding:
iptables -A FORWARD -j DROP

# Open port 1270, enable connection tracking, add the rule to the IN_public_allow chain:
iptables -A IN_public_allow -p tcp -m tcp --dport 1270 -m conntrack --ctstate NEW,UNTRACKED -j ACCEPT
```

#### Open port 80 using firewall-cmd

```shell script
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
iptables-save | grep 80
```

#### Forward port 80 to another host

```shell script
# Enable IP forwarding:
echo 1 > /proc/sys/net/ipv4/ip_forward
/etc/sysctl.conf  (net.ipv4.ip_forward = 1)

# Enable Masquerading:
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Direct traffic on port 80 to the specified destination:
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination 192.168.0.12:80

iptables -A FORWARD -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -m state --state NEW -m tcp -p tcp -d 192.168.0.12 --dport 80 -j ACCEPT
```

#### Enable port forwarding from port 22 to 13579

```shell script
# system-config-firewall > Port Forwarding
# The following rules will be added:
-A PREROUTING -i eth0 -p tcp --dport 22 -j MARK --set-mark 0x64
-A PREROUTING -i eth0 -p tcp --dport 22 -m mark --mark 0x64 -j DNAT --to-destination :13579
-A INPUT -i eth0 -p tcp -m state --state NEW -m tcp --dport 13579 -m mark --mark 0x64 -j ACCEPT

# To enable sshd to use port 13579, add “Port 13570” to /etc/ssh/sshd_config and reload
```

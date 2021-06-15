# Arp displays a table of IP addresses or hostnames with HW addresses.
# This can be helpful in identifying duplicate HW addresses.
cat /proc/net/arp  # print IP addresses and HW addresses
arp -n  # display IP addresses instead of hostnames
arp -s testbox 00:00:00:00:00:00  # sets HWaddress of testbox respectively
arp -d testbox  # deletes HWaddress of testbox from table

netstat -r  # display routing table with gateway and interface
netstat -t  # list only established tcp connections
netstat -atpn  # list established and listening tcp connections with PID, numeric

ss  # socket statistics showing send and receive queues, useful for determining latency

ethtool eth0 | egrep 'Speed|Link'  # speed and link detected of network adaptor

# Wireless networking info:
# Channels 1, 6, and 11 do not overlap.  Try to use a channel that overlaps with the least number of other channels that are in use.
/etc/wpa_supplicant/wpa_supplicant.conf
iwconfig wlan0 | grep Link  # check link quality
iwlist wlan0 scan | egrep '(Channel|Quality)'  # scan for channel numbers and link quality
wpa_cli  # WPA command line client


dig @192.168.0.1 google.com  # lookup google.com through 192.168.0.1
dig +trace amazon.com  # find where domain is registered
dig +short soa amazon.com
dig adobeconnect.digitalriver.com ns  # find name servers for domain
dig -x 8.8.8.8  # reverse dns lookup for 8.8.8.8
host 8.8.8.8  # reverse dns lookup for 8.8.8.8
nslookup 8.8.8.8  # reverse dns lookup for 8.8.8.8


# Trace the route to the given host, wait 2 second for a reply, send 1 probe packet (query) per hop, limit max number of hops to 15, use interface eth0:
traceroute -w 2 -q 1 -m 15 -i eth0 accounts.l.google.com

# Trace route to host, use tcp syn for probes.  This is a transport layer traceroute.
traceroute -T accounts.l.google.com

# Traces path to a network host discovering MTU (Maximum Transmission Unit) along this path:
tracepath google.com


# Find CDP (Cisco Discovery Protocol) information with tcpdump.  Useful for finding make/model and other information of network hardware.

# Verbose output, capture one packet and exit, capture only packets that have a 2 byte value of hex 2000 starting at byte 20.
tcpdump -v -c 1 'ether[20:2] == 0x2000'

# Same as above, but doesn't convert hostname, protocol, port numbers to names.
# More verbose, just traffic on network adapter eth0, and capture 1500 bytes of the packet (typical MTU size).
tcpdump -nn -vvv -i eth0 -s 1500 -c 1 'ether[20:2] == 0x2000'


# Listen for icmp traffic:
tcpdump icmp

# Listen for both icmp and arp traffic:
tcpdump "icmp or arp"

# Capture 100 packets from the host and write to file.  This does not seem to capture CDP info.
tcpdump host 192.168.1.110 -w capture.cap -c 100

# Read the capture file:
tcpdump -r capture.cap | less

# Listen to traffic for host on port 80.  Don’t resolve hostname or port:
tcpdump -nni eth0 host 10.48.116.28 and port 80

# Listen for tcp-syn, and all ack packets:
tcpdump "tcp[tcpflags] & (tcp-syn|tcp-ack) != 0"


# Port scan:

nmap -sS -p 53 8.8.8.8  # scan SYN port 53, after the syn-ack is received, a rst packet is sent
nmap -sA -p 53 8.8.8.8  # scan ACK port 53, useful for finding filtered ports

nmap centoskvm1  # scan for any open ports on centoskvm1
nc -zv google.com 80  # scan port 80
nc -z -w 1 centoskvm1 20-640  # scan ports 20-640
nc -v -i 1 server1 2049  # scan port 2049 (ncat version)
nc -zu centoskvm1 514  # scan udp port 514

nc centoskvm1 22  # connect to port 22 if open on centoskvm1
telnet centoskvm1 22  # connect to port 22 if open on centoskvm1

curl centoskvm1:22  # connect to port 22 and print message from daemon
curl -v centoskvm1:22  # same as above but verbose

# Check a broader range and filter for succeeded connections:
for OCTET3 in `seq 1 255`; do for OCTET4 in `seq 1 255`; do echo $OCTET3 $OCTET4; nc -z -w 1 24.118.$OCTET3.$OCTET4 2222; done; done | tee port2222.txt | grep succeeded

# In a second terminal, check the progress:
tail -f port2222.txt


# Transfer a file with netcat:
nc -l 5900 > ncfile  # listen on port 5900
nc -w 1 tester1 5900 < ncfile  # transfer ncfile to tester1 on port 5900

# Tail a remote log with netcat:
nc -l 5900  # listen on port 5900
tail -f /var/tmp/nclog | nc blackbox 5900  # tail nclog and send to blackbox on 5900


# List memcached stats on memcached server:
echo stats | nc server1 11211

# snmp, get proc and mem info:
snmpwalk -c <public> -v 2c 192.168.1.112 proc
snmpwalk -c <public> -v 2c 192.168.1.112 mem

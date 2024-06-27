# Networking

##### Five Layer Network Model
```
5. Application
4. Transport (TCP, UDP)
3. Network (IP, ICMP)
2. Data Link (ARP)
1. Physical
```

##### Seven-Layer OSI Model
```
7. Application
6. Presentation: adds data conversion, encryption, & compression
5. Session: reply and request streams are viewed as a single session
   of communication between client and server.
4. Transport (TCP, UDP): TCP uses segments for correct order, adds error checking
   and ports allowing different streams of communication.
3. Network (IP, ICMP)
2. Data Link (ARP): hosts on the same network can communicate by MAC address.
1. Physical
```

##### OSI Protocol Data Units (PDU)
| Layer        | Data units                      |
| ------------ | ------------------------------- |
| 5 - 7        | data                            |
| 4. Transport | segments (TCP), datagrams (UDP) |
| 3. Network   | packets                         |
| 2. Data Link | frames                          |
| 1. Physical  | bits                            |

##### Reserved IP addresses
|                               |                                                  |
| ----------------------------- | ------------------------------------------------ |
| 0.0.0.0                       | Can represent all IP addresses                   |
| 255.255.255.255               | IP address used to broadcast to all IP addresses |
| 169.254.0.1 - 169.254.255.254 | IP address range reserved for when DHCP fails    |

##### Reserved private IPv4 network ranges, cannot be used on the Internet
| Class | Start       | End             |
| ----- | ----------- | --------------- |
| A     | 10.0.0.0    | 10.255.255.255  |
| B     | 172.16.0.0  | 172.31.255.255  |
| C     | 192.168.0.0 | 192.168.255.255 |

##### Subnetting

```
Subnet 10.0.0.0/16 has:
Address range: 10.0.0.0 - 10.0.255.255

Divided into two subnets:
Subnets 10.0.0.0/17 and 10.0.128.0/17 have:
Addresses (10.0.0.0 - 10.0.63.255) and (10.0.64.0 - 10.0.255.255)

Divided again:
Subnets (10.0.0.0/18 and 10.0.64.0/18) and (10.0.128.0/18 and 10.0.192.0/18)
Addresses (10.0.0.0 - 10.0.31.255) and (10.0.32.0 - 10.0.63.255)...
```

* Subnetting ensures that traffic between hosts within a subnet stays in that subnet which minimizes congestion.

##### Local communication on a private subnet

1. Devices send ARP requests by IP address for MAC addresses on a local network.
2. Devices reply with MAC address.
3. Packets are encapsulated inside frames and sent between devices.  Frames are added and removed along the route.

```shell script
$ tcpdump "icmp or arp"
14:06:42.950927 ARP, Request who-has 192.168.0.15 tell 192.168.0.13, length 28
14:06:42.953388 ARP, Reply 192.168.0.15 is-at 00:90:a9:3b:df:e0 (oui Unknown), length 46
14:06:48.269061 IP 192.168.0.13 > 192.168.0.15: ICMP echo request, id 18985, seq 0, length 64
14:06:48.271022 IP 192.168.0.15 > 192.168.0.13: ICMP echo reply, id 18985, seq 0, length 64
14:06:49.272453 IP 192.168.0.13 > 192.168.0.15: ICMP echo request, id 18985, seq 1, length 64
14:06:49.274113 IP 192.168.0.15 > 192.168.0.13: ICMP echo reply, id 18985, seq 1, length 64
```

##### TCP 3-Way Handshake

|   | Packet flag & seq     | Direction        |
| - | --------------------- | ---------------- |
| 1 | SYN 4321              | client -> server |
| 2 | SYN 5501, ACK 4322    | client <- server |
| 3 | ACK 5502              | client -> server |

```shell script
# TCP 3-way handshake and termination, the output is trimmed to what's relevant:
tcpdump host google.com

192.168.1.6.61976 > den16s08-in-f14.1e100.net.http: Flags [S], seq 2891417253, win 65535
den16s08-in-f14.1e100.net.http > 192.168.1.6.61976: Flags [S.], seq 3848443320, ack 2891417254, win 65535
192.168.1.6.61976 > den16s08-in-f14.1e100.net.http: Flags [.], ack 1, win 2060
192.168.1.6.61976 > den16s08-in-f14.1e100.net.http: Flags [F.], seq 1, ack 1, win 2060
den16s08-in-f14.1e100.net.http > 192.168.1.6.61976: Flags [F.], seq 1, ack 2, win 256
192.168.1.6.61976 > den16s08-in-f14.1e100.net.http: Flags [.], ack 2, win 2060
```

```shell script
# To establish the connection above, run either of the following:
nc -zv google.com 80
nc -v -w 1 google.com 80
```

##### Duplex
* Full duplex (FDX): traffic can move in both directions simultaneously.
* Half duplex (HDX): traffic can only move in one direction at a time.

##### Ports and Sockets
* A socket is an endpoint of a bidirectional communication that occurs in a computer network that is based on the Internet protocol. 
* A port is a logical data connection that can be used to exchange data without the use of a temporary file or storage.
* A socket is associated with a port and there can be multiple sockets associated with a port.

* A Unix domain socket or IPC socket (inter-process communication socket) is a data communications endpoint for exchanging data between processes executing within the same host operating system.

##### BGP
* The Internet uses Border Gateway Protocol (BGP).
* BGP advertises networks and exchanges routes.

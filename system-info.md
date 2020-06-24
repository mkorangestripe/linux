# Linux System Info

## Linux Distribution
```cat /etc/*release```

```lsb_release -d```

```python -c "import platform; print platform.dist()"```

## Linux Kernel

##### Platform, OS version
```python -c "import platform; print platform.platform()"```

##### Linux kernel version
```cat /proc/version```

##### System info including kernel
```uname -a```

##### Compare running kernel to installed kernels
```uname -r; ls -lt /boot/config*```

##### Show installed kernels
```dkms status```

## System Manufacturer
```dmidecode --string system-manufacturer```

## Hostname

##### Get hostname and system info
```hostnamectl status```

##### Set hostname
```hostnamectl set-hostname server1.domain.com```

## Attached Devices

##### List block devices
```lsblk```
##### List all PCI devices
```lspci```
##### List USB devices
```lsusb```

## CPU

##### CPU info
```cat /proc/cpuinfo```

```lscpu```

##### CPU info on Solaris
```prtdiag | grep CPU```

``` psrinfo```

##### Instruction set architectures on Solaris
```isainfo```

## Memory

##### Memory info
```cat /proc/meminfo```
##### Installed memory on Solaris
```prtconf | grep Mem```
##### Memory info in MB
```free  -m```
##### Virtual memory statistics
```vmstat```

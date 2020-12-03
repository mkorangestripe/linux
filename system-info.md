# Linux System Info

### Linux Distribution
```shell script
cat /etc/*release
lsb_release -d
python -c "import platform; print platform.dist()"
```

### Linux Kernel
```shell script
python -c "import platform; print platform.platform()"  # Platform, OS version
cat /proc/version  # Linux kernel version
uname -a  # System info including kernel
uname -r; ls -lt /boot/config*  # Compare running kernel to installed kernels
dkms status # Show installed kernels
```

### System Manufacturer
```shell script
dmidecode --string system-manufacturer
```

### Hostname
```shell script
hostnamectl status # Get hostname and system info
hostnamectl set-hostname server1.domain.com  # Set hostname
```

### Attached Devices
```shell script
lsblk  # List block devices
lspci  # List all PCI devices
lsusb  # List USB devices
```

### CPU
```shell script
cat /proc/cpuinfo  # CPU info
lscpu  # CPU info
prtdiag | grep CPU  # CPU info on Solaris
psrinfo  # CPU info on Solaris
isainfo  # Instruction set architectures on Solaris
```

### Memory
```shell script
cat /proc/meminfo  # Memory info
prtconf | grep Mem  # Installed memory on Solaris
free -m  # Memory info in MB
vmstat  # Virtual memory statistics
```

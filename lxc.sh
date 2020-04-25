# Install lxc/lxd on Redhat:
# https://computingforgeeks.com/how-to-deploy-lxd-on-centos-7-with-snap/
# https://discuss.linuxcontainers.org/t/lxd-on-centos-7/1250

# Install lxc/lxd on Ubuntu
apt install lxd lxd-client

# Initialize lxd
lxd init

# List lxc remotes (lxd installations)
lxc remote list

# List available images
lxc image list

# List available container flavors
lxc profile list

# List containers with state, ip address, and type
lxc list

# Launch an Ubuntu:16.04 container
lxc launch ubuntu:16.04 ubuntu-test1

# Create an Ubuntu:16.04 container, but do not start
lxc init ubuntu:16.04 ubuntu-test2

# Take a snapshot of a container
lxc snapshot ubuntu-test1 snapshot1

# Show detailed info about a container
lxc info ubuntu-test1

lxc config show ubuntu-test1 # Show detailed configuration of a container
lxc config edit ubuntu-test1 # Live edit container configuration

lxc stop ubuntu-test1 # Stop a container
lxc start ubuntu-test1 # Start a container
lxc restart ubuntu-test1 # Restart a container
lxc pause ubuntu-test1 # Pause a container
lxc delete ubuntu-test1 # Delete a container
lxc delete --force ubuntu-test1 # Delete a running container

lxc file pull ubuntu-test1/etc/hosts . # Copy a file from a container
lxc file push nothing.txt ubuntu-test1/tmp/ # Copy a file to a container
lxc file edit ubuntu-test1/tmp/nothing.txt # Edit a file in a container

# Get a shell on the container
lxc exec ubuntu -- /bin/bash

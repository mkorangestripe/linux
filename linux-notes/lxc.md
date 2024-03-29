# LXC

```shell script
# Initialize lxd:
lxd init

# List lxc remotes (lxd installations):
lxc remote list

# List available images:
lxc image list

# List available container flavors:
lxc profile list

# List containers with state, ip address, and type:
lxc list

# Launch an Ubuntu:16.04 container:
lxc launch ubuntu:16.04 ubuntu-test1

# Create an Ubuntu:16.04 container, but do not start:
lxc init ubuntu:16.04 ubuntu-test2

# Take a snapshot of a container:
lxc snapshot ubuntu-test1 snapshot1

# Show detailed info about a container:
lxc info ubuntu-test1

lxc config show ubuntu-test1  # show detailed configuration of a container
lxc config edit ubuntu-test1  # live edit container configuration

# Get a shell on the container:
lxc exec ubuntu -- /bin/bash
```

```shell script
lxc stop ubuntu-test1            # stop the container
lxc start ubuntu-test1           # start the container
lxc restart ubuntu-test1         # restart the container
lxc pause ubuntu-test1           # pause the container
lxc delete ubuntu-test1          # delete the container
lxc delete --force ubuntu-test1  # delete the running container
```

```shell script
lxc file pull ubuntu-test1/etc/hosts .       # copy a file from a container
lxc file push nothing.txt ubuntu-test1/tmp/  # copy a file to a container
lxc file edit ubuntu-test1/tmp/nothing.txt   # edit a file in a container
```

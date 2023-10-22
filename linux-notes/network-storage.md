# Network storage

#### NFS, SMB

```shell script
# /etc/exports:
/exports *(rw,sync)  # share the /exports directory with any host

systemctl status nfs  # check that the nfs starvice is started
iptables -F           # flush rules if needed
# Check permissions of the exported directory if files are not accessible.

exportfs -a   # export all directories, this shows changes in /etc/exports as additional exports
exportfs -r   # re-export all directories, synchronizing /var/lib/nfs/etab with /etc/exports
exportfs -ua  # unexports all directories
exportfs -v   # show exported directories, verbose

showmount -e server1       # show server1’s nfs export list
showmount -a dc2nfs01.dc2  # show client hostname and mounted directories, may not show current state
rpcinfo server1            # show rpc info for server1

# Mount an nfs directory:
mount -t nfs 192.168.0.111:/exports /mnt/nfs

# Mount a cifs directory requiring a domain password:
sudo mount -t cifs -o user=USAC/a2spyzz -o uid=$UID //winsnas04a/US-LEX-Common /mnt/lexfp01/departments

umount -l  # try if umount -f fails, might need both -lf
```

```shell script
/etc/sysconfig/autofs  # main autofs configuration

# /etc/auto.master:
/misc   /etc/auto.misc  # auto.misc configuration for /misc
/net	-hosts          # allow a host to be specified as in the auto.net script
## Mount nfs home directories listed in /etc/auto.home, in /nfshome:
+auto.master
/nfshome	/etc/auto.home	--timeout=60

man auto.master  # see config examples

# /etc/auto.misc:
nfstest     	-rw,soft,intr       	192.168.0.112:/exports/nfs
systemctl restart autofs
ls /misc/nfstest     # temporarily mounts the nfs share
ln -s /misc/nfstest  # create a symlink, but if the nfs directory is no longer accessible the ls command will hang on the symlink

/etc/auto.net server1              # show server1’s nfs export list using the showmount command
ls /net/192.168.0.112/exports/nfs  # temporarily mount the nfs share

# /etc/auto.home:
* -rw,soft,intr 192.168.1.112:/home/&
# LDAP or NIS authentication is required for shared home directories.
# See /etc/auto.misc for similar examples.
```

#### iSCSI

```shell script
# Connect to an iSCSI storage:
yum install iscsi-initiator-utils                  # install iscsi utilities
iscsiadm -m discoverydb -t st -p 192.168.1.111 -D  # discovery available iSCSI targets
/etc/init.d/iscsi status  # view active sessions
/var/log/messages         # look for new hard drive device file
chkconfig iscsi --list    # verify start on runlevel
/etc/fstab                # setup persistent mount, UUID might be required
```

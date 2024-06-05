# Filesystem Administration

### Symlinks, Hardlinks, Inodes

* Inode - index node, stores all the information about a regular file, directory, or
other file system object, except its data and name.
* Hardlink - a directory entry that associates a name with a file on a file system.
* Symlink - symbolic link, a file that contains a reference to another file or directory.

```shell script
# Create a symlink:
ln -s ~/Documents/ Desktop/

# Show the inode of the Documents dir, notice the trailing slash:
ls -di Desktop/Documents/
# 523283 Desktop/Documents/

# Show the inode of the symlink itself, no trailing slash:
ls -di Desktop/Documents
# 523454 Desktop/Documents
```

The hidden . and .. in directories are hard links to the current directory and the parent directory. Creation of hard links to directories is not permitted by users because the links could cause infinite loops for commands like find and du that traverse the filesystem.

```shell script
# Directories have at least two hardlinks. The 2 after the file permissions in the output below
# indicates two hard links to the same inode as indicated by the first number.
ls -ldi Desktop/
# 2236506 drwxr-xr-x 2 gp gp 4096 Mar 22 20:12 Desktop/

ls -ldi Desktop/.
# 2236506 drwxr-xr-x 2 gp gp 4096 Mar 22 20:12 Desktop/.

# Symlinks to directories can be created, but the behaviour of the symlink
# is not the same as the actually directory.
ln -s ../.. ...  # creates a symlink to the parent’s parent directory
```

### Filesystem

##### Filesystem, device info
```shell script
lsblk -f                  # list block device including fstype, label, uuid, and mountpoint
ls -l /dev/disk/by-path/  # list block devices by path
ls -l /dev/disk/by-uuid/  # list block devices by UUID
ls -l /dev/disk/by-id/    # list block devices by ID including WWNs of LUNs
multipath -ll             # show the current multipath topology...including WWNs of LUNs
fcinfo hba-port           # show WWNs of LUNs on Solaris

mount              # lists mounted filesystems with type
mount | column -t  # lists mounted filesystems with type, output in columns
cat /proc/mounts   # lists all mounted filesystems
cat /proc/mounts | grep -w ro | wc -l  # check for read only filesystems

dumpe2fs /dev/sda1 | grep "Filesystem features"
tune2fs -l /dev/sda1  | grep 'Filesystem created'  # find when the OS was installed
dumpe2fs /dev/sdb1 | grep -i "block count"         # find number of reserved blocks
tune2fs -l /dev/sdb1 | grep -i block               # find number of reserved blocks

tune2fs -j                # add a journal to an ext2
e2label /dev/sdb1 backup  # adds the label ‘backup’ to sdb1

# If a kernel module for a drive isn’t loaded at startup:
modprobe <kernel module>
cat /proc/devices      # lists character and block devices that have modules loaded
lsblk                  # lists block device info including major and minor number
mknod /dev/sda1 b 8 1  # 1st HD, 1st partition, b=block, 8=major, 1=minor

/etc/fstab  # dump = 1 or 0; pass: root dir = 2, others = 1 or 0
```

##### Filesystem usage
```shell script
df -h         # disk usage, human-readable
df -hi        # disk inode usage, human-readable
df -h -F nfs  # nfs disk usage if any exist

du -sh /etc   # total of file sizes in /etc
du -ch *.gz   # total size of gzip’ed files

# Inode usage summary of current directory, top three:
find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort -nr | head -3

# Hard disks can have at most 4 primary partitions or 3 primary with 1 extended
# partition which can point to several logical partitions.

# With block devices with different geometry, recreate the partitions, then dd (copy) the partitions.

# Identify unpartitioned disk space.
# Compare the end cylinder/sector of the last primary/logical
# partition with the total number of cylinders/sectors:
fdisk -luc

lsblk  # compare the sum of the partition sizes with the size of the hard drive

fdisk -uc /dev/sdb  # dos mode off, display units in sectors
```

##### Partprobe, Kpartx
```shell script
partprobe  # inform the OS of partition table changes; if fails, remount the filesystem and run again

# Add partition devmappings, use only if none of the existing partitions were modified,
# might need to restart multipathd beforehand:
kpartx -a /dev/mapper/mpathbp1
```

##### Multipath
```shell script
service multipathd restart  # restart multipathd

multipath -f  # flush a multipath device map specified as parameter, if unused
multipath -F  # flush all unused multipath device maps
multipath -r  # force multipath to reload the device maps

yum install sysfsutils
systool -vc fc_host | grep -w speed  # current speed of Fiber Channel connections
systool -vc fc_host | grep name      # WWNs of various parts

/usr/bin/rescan-scsi-bus.sh  # rescan scsi bus
```

##### Udevadm, Udisks
```shell script
# Reload udev rules and make changes:
udevadm control --reload-rules && udevadm trigger --type=devices --action=change

# Mount/unmount sdb2 in /media/<label> with options (rw,nosuid,nodev,uhelper=udisks)
udisks --mount /dev/sdb2
udisks --unmount /dev/sdb2
```

##### Swap
```shell script
mkswap /dev/sdb2   # make swap
swapon /dev/sdb2   # enable swap using sdb2
swapoff /dev/sdb2  # disable swap using sdb2
cat /proc/swaps    # view swaps, also see 'free' and 'top'
```

##### Repair filesystems, block devices
```shell script
smartctl --all /dev/sda | grep Errors  # check harddrive for errors

# Check/repair filesystems:
# Switch to or start in single user mode or runlevel 1.
mount -o remount,ro /  # mounts the root filesystem read only
fsck                   # this checks all filesystems in the fstab serially
fsck /                 # this checks the root filesystem
```

### Raid

```shell script
cat /proc/mdstat                         # Raid info
mdadm --detail /dev/md[0,1] | grep sync  # Raid sync status

# Raid 10 (striped mirrors) with at least 4 disks has better fault tolerance than Raid 01.
# Either disk in each group could be lost and the array would still function.
# With Raid 01, two disks (one in each group) failing would fail the whole array.
# The loss of any disk from a striped group (Raid 0) will result in the loss of an entire mirror.

# Raid 5 is striping with distributed parity.
# Raid 6 is striping with double distributed parity.
```

### LVM

##### Logical Volume info
```shell script
lvm          # opens lmv prompt, type help
lvmconf      # lvm configuration
lvmdump      # create tarball of diagnostic info
lvmdiskscan  # scan for all lvm devices

# Related commands:
pvs; pvscan; pvdisplay
vgs; vgscan; vgdisplay
lvs; lvscan; lvdisplay

# Check which logical volumes are using the physical volume:
pvdisplay -m /dev/mapper/mpathc

# Check which physical volumes comprise a logical volume:
lvdisplay -m /dev/mapper/vgoracle-lvoracle
```

##### Physical Volumes
```shell script
pvcreate /dev/sdb   # create a physical volume
pvcreate /dev/sdc1  # create a physical volume from a partition

pvremove /dev/sdc2  # remove the PV, wipe label
```

##### Volume Groups
```shell script
vgcreate vg_test /dev/sdb2 /dev/sdc1        # create a volume group from sdb2 and sdc1
vgcreate -s 8m vg_test /dev/sdb1 /dev/sdc1  # ...physical extent size of 8 MB

vgextend vg_test /dev/sdc2  # add physical volume sdc2 to vg_test

vgreduce vg_test /dev/sdb2  # remove PV sdb2 from VG gp_test

vgremove vg_test            # remove the VG

vgchange -a y vg_test       # activate a volume group
```

##### Logical Volumes
```shell script
lvcreate -L 7G vg_test -n lv_test           # create a 7GB LV
lvcreate -l 100%Free vg_test -n lv_test     # create a LV using all free space

lvextend -l +100%Free /dev/vg_test/lv_test  # extend the LV using all free space
lvextend -L +3G /dev/vg_test/lv_test        # extend the LV 3G
lvextend -L +3G -r /dev/vg_test/lv_test     # ...and resize the filesystem
lvextend -L 3G /dev/vg_test/lv_test         # extend the LV to 3G

lvreduce -L -2G /dev/vg_test/lv_test        # reduce the LV 2G
lvreduce -L 2G /dev/vg_test/lv_test         # reduce the LV to 2G

lvremove /dev/vg_test/lv_test               # remove the LV
```

##### Make/Resize a File System on a Logical Volume
```shell script
mkfs -t ext4 /dev/vg_test/lv_test
mkfs -t ext4 /dev/mapper/vg_test-lv_test
mkfs -t ext4 /dev/dm-3

resize2fs -p /dev/vg_test/lv_test     # uses available space
resize2fs -p /dev/vg_test/lv_test 8G  # resize to 8G
xfs_growfs                            # resize xfs filesystem
```

### ZFS on Solaris

```shell script
zfs list   # list file systems
zfs mount  # show currently mounted filesystems

# Set a quota (limit on disk space):
zfs set quota=15G oracle_zpool01/opt_oracle
zfs get quota oracle_zpool01/opt_oracle

# Set a reservation (guaranteed disk space):
zfs set reservation=10G oracle_zpool01/opt_oracle
zfs get reservation oracle_zpool01/opt_oracle

zpool status     # detailed health status of pools
zpool status -v  # verbose, data errors since the last complete pool scrub
zpool status -x  # status of pools with errors and unavailable pools
```

### Volume Encryption

```shell script
yum install cryptsetup-luks  # install cryptsetup-luks
lsmod | grep dm_crypt        # check whether dm_crypt and dm_mod are loaded
modprobe dm_crypt            # load dm_crypt and dm_mod modules

cryptsetup luksFormat /dev/sdb1  # create a LUKS-based filesystem, /dev/dm-? (*1)
cryptsetup luksDump /dev/sdb1    # display the header
cryptsetup luksUUID /dev/sdb1    # display the uuid

# Open the luks partition, create a symlink from /dev/mapper/sdb1-crypt to /dev/dm-? (*2)
cryptsetup luksOpen /dev/sdb1 sdb1-crypt

mkfs -t ext4 /dev/mapper/sdb1-crypt  # create ext4 filesystem  (*3)
mount /dev/mapper/sdb1-crypt /dir1   # mount sdb1-crypt on /dir1

# Prompt for passphrase and mount the encrypted filesystems at startup: (*4)
/etc/crypttab  # sdb1-crypt    /dev/sda1    none
/etc/fstab     # /dev/mapper/sdb1-crypt	/dir1	ext4	defaults	1 2
```

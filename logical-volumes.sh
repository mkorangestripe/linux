# General info
lvm  # opens lmv prompt, type help
lvmconf  # lvm configuration
lvmdump  # create tarball of diagnostic info
lvmdiskscan  # scan for all lvm devices
pvs; pvscan; pvdisplay  # physical volume info
vgs; vgscan; vgdisplay  # volume group info
lvs; lvscan; lvdisplay  # logical volume info

# Check which logical volumes are using the physical volume:
pvdisplay -m /dev/mapper/mpathc

# Check which physical volumes comprise a logical volume:
lvdisplay -m /dev/mapper/vgoracle-lvoracle

# Physical Volumes
pvcreate /dev/sdb  # create a physical volume
pvcreate /dev/sdc1  # create a physical volume from a partition
pvremove /dev/sdc2  # remove the PV, wipe label

# Volume Groups
vgcreate vg_test /dev/sdb2 /dev/sdc1  # create vg from sdb2 and sdc1
vgcreate -s 8m vg_test /dev/sdb1 /dev/sdc1  # create vg with physical extent size of 8 MB
vgextend vg_test /dev/sdc2  # add physical volume sdc2 to vg_test
vgreduce vg_test /dev/sdb2  # remove physical volume sdb2 from VG gp_test
vgremove vg_test  # remove the volume group
vgchange -a y vg_test  # activate a volume group

# Logical Volumes
lvcreate -L 7G vg_test -n lv_test  # create a 7GB lv
lvcreate -l 100%Free vg_test -n lv_test  # create a lv using all free space
lvextend -l +100%Free /dev/vg_test/lv_test  # extend the lv using all free space
lvextend -L +3G /dev/vg_test/lv_test  # extend the lv 3G
lvextend -L +3G -r /dev/vg_test/lv_test  # extend the lv and resize the filesystem
lvextend -L 3G /dev/vg_test/lv_test  # extend the lv to 3G
lvreduce -L -2G /dev/vg_test/lv_test  # reduce the lv 2G
lvreduce -L 2G /dev/vg_test/lv_test  # reduce the lv to 2G
lvremove /dev/vg_test/lv_test  # remove the lv

# Make/Resize a File System on a Logical Volume:
mkfs -t ext4 /dev/vg_test/lv_test
mkfs -t ext4 /dev/mapper/vg_test-lv_test
mkfs -t ext4 /dev/dm-3
resize2fs -p /dev/vg_test/lv_test  # uses available space
resize2fs -p /dev/vg_test/lv_test 8G  # resize to 8G
xfs_growfs  # for xfs filesystem

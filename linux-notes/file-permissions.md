# File Permissions, SELinux

#### setuid, setgid on binary files

```shell script
# setuid — used only for binary files, the file is executed with the permissions of the file owner:
chmod u+s <file>

# Regular users can execute passwd, but passwd will not update /etc/passwd:
chmod u-s /usr/bin/passwd

# setgid — used primarily for binary files, the file is executed with the group owner permissions:
chmod g+s <file>
```

#### setuid, setgid on directories

```shell script
# The setuid bit on a directory is ignored on UNIX and Linux systems:
chmod u+s <directory>

# Files created in this directory will have the same group owner as the dir:
chmod g+s <directory>
```

#### Sticky bit

```shell script
# Used primarily on directories, this bit dictates that a file created in the directory
# can be removed only by the user that created the file.
chmod +t <dir>
# T denotes the directory is not other-executable and has the sticky bit set.
# t denotes the directory is other-executable and has the sticky bit set.
```

#### Directory permissions

```shell script
# chmod 644 on a directory:
# If r-- is set on a dir, the files can be listed, but the files cannot be read.
# If --x is set on a dir, the files cannot be listed, but the files could be read
# if the file name is known and the permissions allow reading.

chmod -c mike:mike apples.txt  # changes owner and group owner to mike
```

#### Timestamps

```shell script
stat    # display file info including timestamps

ls -l   # Modify time, mtime, the last time the file contents were changed
ls -lu  # Access time, atime, the last time the file was read
ls -lc  # Change time, ctime, the last time the file’s permissions, ownership, etc, were changed
ls -lrt # sort by timestamp, reverse order
ls --full-time

# Set the mtime of FILE2 to the mtime of FILE1:
MTIME=$(stat -c %y $FILE1)
touch -d "$MTIME" $FILE2

# Set the timestamps of FILE2 using FILE1 as a reference:
touch -r $FILE1 $FILE2
```

#### File attributes

```shell script
chattr +i <file>  # makes file immutable, must be run as root
chattr +a <file>  # makes file append only, must be run as root
lsattr            # list attributes
```

#### ACLs

```shell script
mount -o remount,acl <file system>  # acl seems to work with or without
setfacl -m u:gp:r-x <file>  # sets read and execute for gp
setfacl -x u:gp <file>      # removes acl entries, -b removes all acl
setfacl -m u:gp:--- <file>  # removes all entries only for gp
setfacl -m mask:r <file>    # sets effective entries for acl
getfacl  # get file access control list
# Setting an acl puts a + at the end of regular s.

# Share a directory in testuser1’s home directory with testuser2.
# Basically, the directory path to the files need to be executable and the files need to be readable:
setfacl -m u:testuser2:x /home/testuser1           # allows access to subdirectories
setfacl -m u:testuser2:r /home/testuser1/copper/*  # allows read access to the files
```

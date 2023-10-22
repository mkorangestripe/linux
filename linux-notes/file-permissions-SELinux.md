# File Permissions, SELinux

```shell script
# setuid, setgid (binary files)
# setuid — used only for binary files, the file is executed with the permissions of the file owner:
chmod u+s <file>
# Regular users can execute passwd, but passwd will not update /etc/passwd:
chmod u-s /usr/bin/passwd
# setgid — used primarily for binary files, the file is executed with the group owner permissions:
chmod g+s <file>

# setuid, setgid (directories)
# The setuid bit on a directory is ignored on UNIX and Linux systems:
chmod u+s <directory>
# Files created in this directory will have the same group owner as the dir:
chmod g+s <directory>

# sticky bit
# Used primarily on directories, this bit dictates that a file created in the directory
# can be removed only by the user that created the file.
chmod +t <dir>
# T denotes the directory is not other-executable and has the sticky bit set.
# t denotes the directory is other-executable and has the sticky bit set.
```

```shell script
stat  # display timestamps, etc.

# Set the mtime of FILE2 to the mtime of FILE1:
MTIME=$(stat -c %y $FILE1)
touch -d "$MTIME" $FILE2

# Set the timestamps of FILE2 using FILE1 as a reference:
touch -r $FILE1 $FILE2

# Timestamps:
ls -l   # Modify time, mtime, the last time the file contents were changed
ls -lu  # Access time, atime, the last time the file was read
ls -lc  # Change time, ctime, the last time the file’s permissions, ownership, etc, were changed
ls --full-time
ls -t   # sort by timestamp

# File Attributes:
chattr +i <file>  # makes file immutable, must be run as root
chattr +a <file>  # makes file append only, must be run as root
lsattr
```

```shell script
# ACLs:
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

```shell script
# chmod 644 on a directory:
# If r-- is set on a dir, the files can be listed, but the files cannot be read.
# If --x is set on a dir, the files cannot be listed, but the files could be read
# if the file name is known and the permissions allow reading.

chmod -c mike:mike apples.txt  # changes owner and group owner to mike
```

#### SELinux

```shell script
# SELinux Additional Packages:
yum install policycoreutils-python  # provides semanage
yum install policycoreutils-gui     # provides system-config-selinux
yum install setroubleshoot-server   # provides sealert

# SELinux Status / Settings:
sestatus
# Modes: enforcing, permissive, disabled
# Policies: targeted, mls
# Default is enforcing/targeted, cannot configure during install
# To disable selinux, edit /etc/sysconfig/selinux and reboot.
getenforce
setenforce <enforcing> <permissive>

# SELinux Security Contexts:
ls -Z   # user, role, type, level
ps -eZ  # user, role, type, level
chcon <-R> -u <user> -t <type> <file or dir>
chcon --reference /var/ftp/pub /ftp                 # change context of /ftp using /var/ftp/pub as reference
/etc/selinux/targeted/contexts/files/file_contexts  # first line is default for restorecon
restorecon -F <filename>  # force reset on context
# Set the default selinux context of /ftp:
semanage fcontext -a -s system_u -t public_content_t /ftp  # set the default context for /ftp
/etc/selinux/targeted/contexts/files/file_contexts.local   # /ftp should now appear in this file

# SELinux, Regular Users:
semanage login -l
id -Z  # does not update after using su
# Configure a user role, changes not in effect until next login:
semanage login -a -s user_u mike
semanage login -d -s user_u mike
# Set default for future users:
semanage login -m -S targeted -s "user_u" -r s0 __default__
semanage login -m -S targeted -s "unconfined_u" -r s0-s0:c0.c1023 __default__

# SELinux Boolean Settings:
getsebool -a         # lists booleans in /selinux/booleans/
semanage boolean -l	 # description of booleans
Allow or disallow user to execute scripts in home dir or /tmp  # sh script.sh still works:
setsebool -P allow_user_exec_content <on or off> or <1 or 0>   # -P for persistent
getsebool allow_user_exec_content  # shows if on or off

# SELinux Policy Violations:
/etc/init.d/auditd       # responsible for writing audits
ausearch -m avc -c sudo  # lists all SE events associated with sudo
sealert -a /var/log/audit/audit.log  # SE denials and attempts
sealert -b  # launch browser
```

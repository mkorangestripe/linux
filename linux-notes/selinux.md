
# SELinux

#### Additional Packages

```shell script
yum install policycoreutils-python  # provides semanage
yum install policycoreutils-gui     # provides system-config-selinux
yum install setroubleshoot-server   # provides sealert
```

#### Status / Settings

```shell script
sestatus
# Modes: enforcing, permissive, disabled
# Policies: targeted, mls
# Default is enforcing/targeted, cannot configure during install
# To disable selinux, edit /etc/sysconfig/selinux and reboot.

getenforce
setenforce <enforcing> <permissive>
```

#### Security Contexts

```shell script
ls -Z   # user, role, type, level
ps -eZ  # user, role, type, level

chcon <-R> -u <user> -t <type> <file or dir>
chcon --reference /var/ftp/pub /ftp                 # change context of /ftp using /var/ftp/pub as reference

/etc/selinux/targeted/contexts/files/file_contexts  # first line is default for restorecon
restorecon -F <filename>                            # force reset on context

# Set the default selinux context of /ftp:
semanage fcontext -a -s system_u -t public_content_t /ftp  # set the default context for /ftp
/etc/selinux/targeted/contexts/files/file_contexts.local   # /ftp should now appear in this file
```

#### Regular Users

```shell script
semanage login -l

id -Z  # does not update after using su

# Configure a user role, changes not in effect until next login:
semanage login -a -s user_u mike
semanage login -d -s user_u mike

# Set default for future users:
semanage login -m -S targeted -s "user_u" -r s0 __default__
semanage login -m -S targeted -s "unconfined_u" -r s0-s0:c0.c1023 __default__
```

#### Boolean Settings

```shell script
getsebool -a         # lists booleans in /selinux/booleans/
semanage boolean -l	 # description of booleans

# Allow or disallow user to execute scripts in home dir or /tmp. sh script.sh still works:
setsebool -P allow_user_exec_content <on or off> or <1 or 0>   # -P for persistent
getsebool allow_user_exec_content  # shows if on or off
```

#### Policy Violations

```shell script
/etc/init.d/auditd       # responsible for writing audits
ausearch -m avc -c sudo  # lists all SE events associated with sudo
sealert -a /var/log/audit/audit.log  # SE denials and attempts
sealert -b               # launch browser
```

# User Administration

#### User accounts

```shell script
/etc/skel/                        # default files and folders for new accounts

/usr/sbin/adduser -> useradd      # symlimk
useradd mike -e 2013-03-06        # create an account for mike with expiration date 2013-02-06

semanage login -a -s user_u mike  # optional, add mike as an selinux user

usermod -aG training mike         # append mike to the training group
userdel -r mike                   # deletes mike and his home dir

groupadd -g 500700 project        # create a group named ‘project’ with GID 500700
groupmod -g 123456 project        # change the GID of project to 123456
groupdel project                  # deletes the group named ‘project’

chage -l mike                     # list account aging information for mike
chage -E 2013-02-06 mike          # expire mike's user account on 2013-02-06
chage -m 2 -M 30 temp1            # set mike’s password life to: min 2 days, max 30 days

# Default min and max password life:
/etc/login.defs  # PASS_MAX_DAYS, PASS_MIN_DAYS

passwd -S user1     # status of user1’s password
passwd -x 0 user1   # set max password life to 0 days
passwd -x -1 user1  # turn of aging for password
passwd -e user1     # expires password forcing change at next login
passwd -d user1     # delete password
passwd -l user1     # lock account, -u unlocks

passwd -r files user1  # specifies the ‘files’ repository on Solaris
# By default /etc/nsswitch.conf determines the repository: files, ldap, nis, or nisplus.

# Enter in /etc/passwd to disable interactive login for a user,
# this will prevent logins even if the account uses an ssh key:
/sbin/nologin

/etc/securetty  # can be used to limit terminals
```

#### /etc/sudoers


```shell script
# Edit /etc/sudoers with visudo to avoid simultaneous edits and parse errors.

# Format of lines in /etc/sudoers:
user host=(user:group) tag:commands

host          # specifies which host the command can be run from
(user:group)  # specifies which user or group the command can be run as

# Allow members of the wheel group, connected from any host,
# as any user, without requiring a password, to run any command:
%wheel	ALL=(ALL)   	NOPASSWD: ALL

# Allow members of the wheel group, connected from any host, as any user, to run any command:
%wheel   	ALL=(ALL)   	ALL

# Allow members of the wheel group, connected from any host,
# without providing a password, to install system updates:
%wheel  ALL=NOPASSWD:/usr/bin/yum -y update

# On Ubuntu - allow members of the sudo group, connected from any host,
# without providing a password, to install system updates:
Cmnd_Alias UPDATE_CMDS=/usr/bin/apt-get -y update, /usr/bin/apt-get -y dist-upgrade
%sudo   ALL=	NOPASSWD:UPDATE_CMDS

# Allow gp, connected from localhost, to reboot the system:
gp  localhost=/usr/bin/reboot

# Allow members of the wheel group, connected from any host,
# without providing a password, to list disk information:
%wheel  ALL=NOPASSWD:/sbin/fdisk -luc
```

#### sudo, su

```shell script
sudo su -           # login as root
sudo su - user1     # login as user1
sudo fdisk -luc     # run fdisk using sudo
su -c “fdisk -luc”  # run fdisk as root, this will prompt for root’s password
```

#### Group passwords
```shell script
gpasswd temps                 # set a group password for the temps group
sg temps -c 'ls /home/temps'  # prompt for the group password then execute ls as a member of temps
```

#### Logins

```shell script
last                   # show listing of last logged in users
last -f /var/log/wtmp  # login history from a file
lastlog -u mike        # reports the most recent login of mike
/var/log/secure        # logins and failed attempts
```

#### NIS

```shell script
/etc/init.d/ypbind  # NIS service
/etc/init.d/nis     # NIS service on Ubuntu
/etc/yp.conf        # contains NIS servers
/etc/defaultdomain  # contains default domain on Ubuntu

ypwhich  # show the NIS server

ypcat passwd | grep user1         # print NIS user entry
ypcat group | grep devprod        # print NIS group entry
ypcat -k netgroup | grep devprod  # print NIS netgroup entry

# Add Nis netgroup to a system:
# Add +@devprod to /etc/passwd and /etc/shadow
# Add +devprod or just + to /etc/group
```

#### LDAP

```shell script
# Install ldap on a client:
yum install openldap-clients openldap nss-pam-ldapd

# Simple ldap client configuration:
system-config-authentication
User Account Database: LDAP
LDAP Search Base DN: dc=example,dc=net  # where the domain name is example.net
LDAP Server: ldaps://192.168.122.1      # where the ldap server is 192.168.122.1
Authentication Method: LDAP password

# ldap configuration files:

# /etc/openldap/ldap.conf - should include the following lines:
URI ldaps://192.168.122.1
BASE dc=example, dc=net

# /etc/pam_ldap.conf - might be necessary for TSL encryption

# /etc/nsswitch.conf - should include the following lines:
passwd: 	files sss
shadow: 	files sss
group:  	files sss
```

# Package Management

To schedule package updates with cron, see [package-updates](../package-updates)

#### RPM

```shell script
rpm -ihv  <package>                  # standard verbose install command, use for kernel updates
rpm -uhv <package>                   # same as -ihv but removes other versions of the package
rpm -ihv ftp://ftp.redhat.com/<rpm>  # install from an ftp server
rpm -e <package to erase>            # erase package
rpm -e --nodeps <package to erase>   # no dependency check before uninstalling

rpm -qa gpg-pubkey   # outputs which keys are in the rpm database
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
rpm -qa              # lists all installed packages
rpm -qf <filename>   # identifies package associated with a file
rpm -qc <package>    # lists config files from a package
rpm -qi <package>    # displays basic info of a package
rpm -ql <package>    # lists all files from a package
rpm -qR <package>    # lists all dependencies

rpm --rebuilddb      # rebuild rpm database(s) in /var/lib/rpm

rpm --verify -p <package>
rpm --verify --file <filename>
rpm -Va              # verify all packages, beware of changes in binaries
```

#### Yum

```shell script
yum repolist   # list configured repositories
yum list       # all, installed, available, updates, extras
yum list nmap  # shows packages for nmap
yum info nmap  # shows more detailed info of packages for nmap
yum provides /usr/bin/nmap                    # show which package provides nmap
yum --showduplicates list java-1.8.0-openjdk  # show other available versions of java

yum clean all       # removes old packages, also can resolve update failures
yum clean metadata  # clean metadata

yum check-update                  # check for updates
yum update -y                     # yes to all updates
yum update --disableexclude=main  # disable excludes in the main section of /etc/yum.conf

yum grouplist             # lists package groups
yum groupinfo <group>     # lists packages in the group
yum groupinstall <group>  # does not install optional packages, use -x to exclude packages
yum groupremove <group>   # removes all packages in group

yum install --nogpgcheck httpd       # install httpd without the gpg check
yum -y install yum-plugin-security   # security plugin for updating errata only
yum -y --security update -x kernel*  # update errata excluding kernel packages
yum reinstall kernel                 # reinstall the kernel package

yumdownloader kernel           # downloads the latest kernel package to the local directory
yumdownloader kernel-firmware  # downloads the latest kernel firmware to the local directory

yum history list {all}  # list last transactions, 20 is default
yum history redo last   # redo last transaction
yum history undo last   # undo last transaction

yum-complete-transaction --cleanup-only  # attempt to complete failed transactions, journal files only

gpk-prefs  # GNOME PackageKit Update Preferences
```

#### Apt, dpkg

```shell script
dpkg -l               # list installed packages
dpkg -i wget.deb      # install the wget package
dpkg -r wget          # remove wget
dpkg -P wget          # purge - remove wget package and config files

apt list --installed  # list installed packages
apt search wget       # search for wget packages
apt install wget      # install wget
apt remove wget       # remove wget

apt clean             # remove deb files from /var/cache/apt/archives
apt autoclean         # remove obsolete deb files from /var/cache/apt/archives
apt autoremove        # remove unneeded deb files from /var/cache/apt/archives installed as dependencies

apt-cache rdepends --installed gcc-10-base      # list installed packages with a gcc-10-base dependency

sudo apt update && sudo apt -y dist-upgrade     # update and dist-upgrade the localhost
sudo sh -c “apt update && apt -y dist-upgrade”  # same as above but useful when sudo permission may timeout

# An alias for the above update commands:
UPD_CMD='"apt update && apt -y dist-upgrade"'
alias upd="echo $UPD_CMD; sudo sh -c $UPD_CMD"
```

#### Homebrew on macOS

```shell script
brew tap                    # list repositories

brew update                 # update the formulae and Homebrew itself
brew outdated               # show outdated with current / available versions
brew upgrade                # upgrade all packages
brew upgrade ansible        # upgrade ansible

brew list                   # list installed packages
brew leaves                 # list installed packages that are not dependencies of others installed

brew info ipython           # show info about the ipython package
brew search cassandra       # search for cassandra packages

brew install ipython        # install ipython
brew uninstall ipython      # uninstall ipython
brew link docker            # create necessary symlinks for the application

brew list --cask            # list packages installed by homebrew cask
brew outdated --cask        # show outdated cask packages
brew search --cask docker   # search for docker cask packages
brew install --cask docker  # install docker desktop

brew deps wget              # show dependencies for wget
brew deps --tree wget       # show dependencies for wget as a tree
brew deps --graph wget      # show dependency graph for wget in browser

brew uses --installed --recursive openssl  # list installed packages that depend on openssl
```

```shell script
xcode-select --install      # update Xcode CommandLineTools on OSX
```

#### Yum repo files

```shell script
man yum.conf  # the repository options section has a simple example

/etc/yum.repos.d/CentOS-Base.repo:
[base]
name=CentOS-$releasever - Base
baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/

/etc/yum.repos.d/bluebird.repo:
[bluebird]
name=bluebird-ftp-repo
baseurl=ftp://192.168.122.1/pub/os

/etc/yum.conf:
exclude=kernel* mdadm  # exclude all kernel packages and mdadm from updates
```

#### Remote host updates with Yum

```shell script
# Update just 192.168.0.11:
ssh -t 192.168.0.11 sudo yum -y update

# Update all VMs in VMhostlist.txt, two at time:
cat ~/.VMhostlist.txt | xargs -P2 -I HOST ssh -tt HOST sudo yum -y update

# Update all VMs in the space delimited VMHL variable:
echo $VMHL | xargs -n 1 | xargs -P 2 -I HOST ssh -tt HOST sudo yum -y update
```

#### Create an RPM package

```shell script
# http://www.oracle-base.com/articles/linux/linux-build-simple-rpm-packages.php
yum groupinstall "Development tools"   # this provides gcc, and others
yum install rpm-build rpmdevtools      # install build tools
rpmdev-setuptree                       # create rpmbuild directory structure
cd rpmbuild
mkdir testscript-1.0
echo "echo \"This is a test\"" > testscript-1.0/testscript.sh
tar cvzf SOURCES/testscript-1.0.tar.gz testscript-1.0
rpmdev-newspec SPECS/testscript.spec   # edit this file as needed
rpmbuild -bb -v SPECS/testscript.spec  # build a binary package
```

#### Alternatives

```shell script
# Set a specific version of java as the system default:
alternatives --install /usr/bin/java java /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.45-28.b13.el6_6.x86_64/jre/bin/java 1
alternatives --config java

update-alternatives --get-selections  # list all alternatives
update-alternatives --config editor   # change default editor
```

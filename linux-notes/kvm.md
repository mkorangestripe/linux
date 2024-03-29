# KVM

```shell script
egrep "vmx|svm" /proc/cpuinfo  # check for virtualization extensions
lsmod | grep kvm    # verify that the kvm kernal modules are loaded after installation
modprobe kvm        # add kvm module to the kernel
virsh capabilities  # lists capabilities of local hypervisor
```


```shell script
/etc/libvirt/qemu/       # config files for VMs
/var/lib/libvirt/images  # VM images
/etc/init.d/libvirtd     # VM service (SysV init)
```

```shell script
virt-install --prompt  # create new VM

# virt-install from FTP with a Kickstart file:
virt-install -n tester1 -r 1024 --disk path=/var/lib/libvirt/images/tester1,size=10 -l ftp://192.168.1.110/pub/inst/centos6 -x "ks=ftp://192.168.1.110/pub/ks.cfg"

virt-clone --prompt  # clone a VM
```

```shell script
virsh autostart <domain>
virsh autostart --disable <domain>
grep -i start /etc/libvirt/qemu/autostart/centoskvm1.xml

virsh list --all     # list all domains, on and off
virsh dominfo <VM>
virsh edit <domain>  # edit the xml of a domain

virsh net-list            # lists networks
virsh net-info <network>  # show network info
```

```shell script
virsh start <VM>     # start a domain
virsh reboot <VM>    # reboot a domain
virsh shutdown <VM>  # shutdown a domain
virsh destroy <VM>   # stop a domain
```

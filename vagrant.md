# Vagrant Notes

### VirtualBox

```shell script
VBoxManage list vms  # list VirtualBox vm's
VBoxManage list vms -l  # list VirtualBox vm's with more details
VBoxManage list hostonlyifs  # list host-only network interfaces
```

### Vagrant

```shell script
# Login to Vagrant Cloud:
vagrant login  # old command
vagrant cloud auth login  # new command

vagrant global-status  # show status of all VMs
vagrant status 2a44541  # show status of given VM

vagrant box list  # list vagrant boxes
vagrant box add  # to add additional boxes to the Vagrantfile
vagrant box add vagrant-windows-2016 ~/windowsserver-2016.box  # add vagrant box from file
vagrant box update  # update the vagrant box
vagrant box remove  #  remove the box file (downloaded image)

vagrant init bento/ubuntu-18.04.  # create the Vagrant file with bento/ubuntu-18.04
vagrant up  # download the box file if not already and start the VM
vagrant suspend  # suspends the machine
vagrant halt  # stops the vagrant machine
vagrant destroy  # shutdown VM, remove VirtualBox files, reclaim RAM

vagrant reload  # reload configuration in Vagrantfile
vagrant provision  # provision the vagrant machine based on the Vagrantfile, e.g. with ansible

vagrant ssh aae63f6  # login to VM by id, defualt VM if run without id
vagrant ssh-config  # show vagrant ssh info including private key location
vagrant port  # show port forwarding from guest to host
```

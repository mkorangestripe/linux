VBoxManage list vms # list VirtualBox vm's
VBoxManage list vms -l # list VirtualBox vm's with more details
VBoxManage list hostonlyifs # list host-only network interfaces

vagrant init bento/ubuntu-18.04. # create the Vagrant file with bento/ubuntu-18.04
vagrant box add # to add additional boxes to the Vagrantfile
vagrant global-status # get status of all VM's
vagrant status
vagrant up # download the box file if not already and start the VM
vagrant suspend # suspends the machine
vagrant halt # stops the vagrant machine
vagrant destroy # shutdown VM, remove VirtualBox files, reclaim RAM
vagrant box remove # also remove the box file - downloaded image
vagrant ssh
vagrant ssh-config # show vagrant ssh info

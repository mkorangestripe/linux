# Ansible config file:
/etc/ansible/ansible.cfg

# Ansible hosts file:
/etc/ansible/hosts

ansible-doc -l  # list all modules
ansible-doc -s lineinfile  # show info on given module


# Setup Ansible

# On the control node:
useradd ansible

# On the hosts:
useradd ansible
passwd ansible

# From the control node:
sudo su - ansible
ssh-keygen
ssh-copy-id server1

# On the hosts:
visudo
ansible ALL=(ALL) NOPASSWD: ALL

# Verify the connection to the hosts:
ansible server1 -m ping
ansible server1 -m setup


# Ansible Ad hoc Commands
ansible server1 -a "cat /proc/cpuinfo" | grep "cpu cores"
ansible vms -a "cat /proc/cpuinfo" | grep "cpu cores"


# Install httpd on a host
ansible server1 -b -m yum -a "name=httpd state=latest"
ansible server1 -b -m service -a "name=httpd state=started"


# Run a playbook

ansible-playbook web.yml --check  # dry run
ansible-playbook -i inv web.yml  # run web.yml playbook against given inventory file
ansible-playbook --limit web.retry  # rerun only on failed hosts

# Run a playbook using variables
ansible-playbook web2.yml -e \
"target_hosts=server1 \
target_service=httpd";

# Run a playbook using handlers (specified in the playbook)
ansible-playbook web3.yml -e "target_service=httpd"

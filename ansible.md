# Ansible notes

### Ansible config files, modules

```shell script
/etc/ansible/ansible.cfg  # Ansible config file

/etc/ansible/hosts  # Ansible hosts file

ansible-doc -l  # list all modules
ansible-doc -s lineinfile  # show info on the given module
```

### Setup Ansible

```shell script
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
```

### Ansible ad-hoc commands

```shell script
ansible server1 -a "cat /proc/cpuinfo" | grep "cpu cores"
ansible vms -a "cat /proc/cpuinfo" | grep "cpu cores"

# Install httpd on a host:
ansible server1 -b -m yum -a "name=httpd state=latest"
ansible server1 -b -m service -a "name=httpd state=started"
```

### Ansible playbooks

```shell script
ansible-playbook web.yml --check  # dry run
ansible-playbook -i inv web.yml  # run web.yml playbook against the given inventory file
ansible-playbook --limit web.retry  # rerun only on failed hosts

# Run a playbook using variables
ansible-playbook web2.yml -e \
"target_hosts=server1 \
target_service=httpd";

# Run a playbook using handlers (specified in the playbook):
ansible-playbook web3.yml -e "target_service=httpd"
```
# Ansible notes

### Ansible config files, modules

```shell script
# Ansible config file, searched in the following order:
~/ansible.cfg
~/.ansible.cfg
/etc/ansible/ansible.cfg

/etc/ansible/hosts  # Default Ansible hosts file, but specified in ansible.cfg

ansible-config view  # view ansible configuration file

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
ansible server1 -a "cat /proc/cpuinfo" | grep "cpu cores"  # run command on a single host
ansible vms -a "cat /proc/cpuinfo" | grep "cpu cores"  # run command on hosts in vms host group

# Install httpd on a Red Had host:
ansible server1 -b -m yum -a "name=httpd state=latest"
ansible server1 -b -m service -a "name=httpd state=started"

# Test the connection to Windows hosts:
nc -vz server1 5986  # check the https port used by winrm
kinit user1@SOMEDOMAIN.COM  # authenticate with Kerberos
ansible all -m win_ping -i inventory.yml --user user1@SOMEDOMAIN.COM
```

### Ansible playbook commands

```shell script
ansible-playbook web.yml --check  # dry run
ansible-playbook -i inv web.yml  # run web.yml playbook against the given inventory file
ansible-playbook --limit web.retry  # rerun only on failed hosts

ansible-vault create secrets.yml  # encrypt file
ansible-playbook update_inventory.yml --ask-vault-pass  # prompt for vault password

# Run a playbook using variables:
ansible-playbook web2.yml -e \
"target_hosts=server1 \
target_service=httpd";

# Run a playbook against Windows hosts:
nc -vz server1 5986  # check the https port used by winrm
kinit user1@SOMEDOMAIN.COM  # authenticate with Kerberos
ansible-playbook chef-client.yml -i inventory.yml --user user1@SOMEDOMAIN.COM
```

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
ansible all -i server1, -m ping -u user1 -k  # test connection to Linux host

# Test the connection to Windows hosts:
nc -vz server1 5986  # check the https port used by winrm
kinit user1@somedomain.com  # authenticate with Kerberos
ansible all -m win_ping -i inventory.yml -u user1@somedomain.com  # login using Kerberos authentication
ansible -i visualcron.ini dev -m win_ping -u user1 -k  # login with username and password

# Find kerberos servers (PowerShell):
nslookup -type=srv _kerberos._tcp.somedomain.com

ansible all -i server100, -a "uname -a" -u SUDOUSER -k  # run command on a single host, prompt for password
ansible vms -a "cat /proc/cpuinfo" | grep "cpu cores"  # run command on hosts in vms host group

# Run the command on the host group in the inventory file, as root, output one line per host, prompt for password:
ansible -i appd-docker-images.ini 5009ea0cc087 -b -m shell -a 'docker images | grep -i appd' -o -u sudouser1 -k

# Copy and run the script on all hosts in the inventory file:
ansible -i lin-prod.ini all -b -m script -a "scx-1.6.8-1.universalr.1.x64.sh --upgrade" -u sudouser1 -k

# Install httpd on a Red Hat host:
ansible server1 -b -m yum -a "name=httpd state=latest"
ansible server1 -b -m service -a "name=httpd state=started"
```

### Ansible playbook commands

```shell script
ansible-playbook update_visualcron.yml -i visualcron.ini --syntax-check
ansible-lint update_visualcron.yml  # checks and recommendations
ansible-playbook web.yml --check  # dry run

ansible-playbook -i inv web.yml  # run web.yml playbook against the given inventory file
ansible-playbook --limit web.retry  # rerun only on failed hosts

ansible-vault create secrets.yml  # encrypt file
ansible-playbook update_inventory.yml --ask-vault-pass  # prompt for vault password

# Run a playbook using variables:
ansible-playbook web2.yml -e \
"target_hosts=server1 \
target_service=httpd";

# Run a playbook against Windows hosts using Kerberos authentication:
kinit user1@somedomain.com  # authenticate with Kerberos
ansible-playbook chef-client.yml -i inventory.yml -u user1@somedomain.com
```

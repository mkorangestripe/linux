# Ansible

### Ansible config files, modules

```shell script
# Ansible config file, searched in the following order:
~/ansible.cfg
~/.ansible.cfg
/etc/ansible/ansible.cfg

ansible-config view  # view ansible configuration file

/etc/ansible/hosts   # default Ansible hosts file, but specified in ansible.cfg
```

```shell script
ansible-doc -l             # list all modules
ansible-doc -s lineinfile  # show info on the given module
```

### Setup Ansible

Control node

```shell script
useradd ansible

sudo su - ansible
ssh-keygen
ssh-copy-id server1  # ansible user must be on the hosts

# Verify the connection to the hosts:
ansible -i server1, all -m ping
ansible -i server1, all -m setup
```

Hosts

```shell script
useradd ansible
passwd ansible

visudo  # add the following line
ansible ALL=(ALL) NOPASSWD: ALL
```

### Ansible ad-hoc commands

Test connection to hosts

```shell script
ansible -i server1, all -m ping -u user1 -k  # test connection to Linux host

# Test the connection to Windows hosts:
nc -vz server1 5986                                               # check the https port used by winrm
kinit user1@somedomain.com                                        # authenticate with Kerberos
ansible -i inventory.yml all -m win_ping -u user1@somedomain.com  # login using Kerberos authentication
ansible -i visualcron.ini dev -m win_ping -u user1 -k             # login with username and password

nslookup -type=srv _kerberos._tcp.somedomain.com  # Find kerberos servers (PowerShell)
```

Run commands on hosts

```shell script
ansible -i server100, all -a "uname -a" -u SUDOUSER -k  # run command on a single host, prompt for password
ansible vms -a "cat /proc/cpuinfo" | grep "cpu cores"   # run command on hosts in vms host group

# Run the command on the host group in the inventory file,
# as root, output one line per host, prompt for password:
ansible -i appd-docker-images.ini 5009ea0cc087 -b -m shell -a 'docker images | grep -i appd' -o -u sudouser1 -k

# Copy and run the script on all hosts in the inventory file:
ansible -i lin-prod.ini all -b -m script -a "scx-1.6.8-1.universalr.1.x64.sh --upgrade" -u sudouser1 -k

# Install httpd on a Red Hat host:
ansible -i server1, all -m yum -a "name=httpd state=latest" -b
ansible -i server1, all -m service -a "name=httpd state=started" -b 
```

### Ansible-playbook

Checks and dry runs

```shell script
ansible-lint update_visualcron.yml                                                 # linting
ansible-playbook update_visualcron.yml --syntax-check                              # check for syntax errors

ansible-playbook update_visualcron.yml -i visualcron.ini -l dev --list-hosts       # just list targeted hosts
ansible-playbook update_visualcron.yml -i visualcron.ini -l dev -k --diff --check  # show diff, dry run
ansible-playbook update_visualcron.yml -i visualcron.ini -l dev -k --check         # dry run
```

Run playbooks on hosts

```shell script
# Run the update_visualcron.yml playbook against the dev group in /etc/ansible/hosts, prompt for password:
ansible-playbook update_visualcron.yml -l dev -k

# Run the update_visualcron.yml playbook against the dev group
# in the visualcron.ini inventory file, prompt for password:
ansible-playbook update_visualcron.yml -i visualcron.ini -l dev -k

# Run only the tasks with the 'pip' tag in the playbook:
ansible-playbook deploy_custom_linux_monitor.yml -t pip -i datadog.ini -k

ansible-playbook -l web.retry  # rerun only on failed hosts

ansible-vault create secrets.yml                        # encrypt secrets.yml
ansible-playbook update_inventory.yml --ask-vault-pass  # prompt for vault password

# Run a playbook using variables:
ansible-playbook web2.yml -e \
"target_hosts=server1 \
target_service=httpd";

# Run a playbook against Windows hosts using Kerberos authentication:
kinit user1@somedomain.com  # authenticate with Kerberos
ansible-playbook chef-client.yml -i inventory.yml -u user1@somedomain.com
```

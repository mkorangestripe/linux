# General info

# Control Cluster:
# Horizon (dashboard)
# Keystone (identity)
# Neutron (network)
# Glance (image)
# Nova (compute)
# Ceph (distributed object storage)
# Cinder (block storage)
# Heat (orchestration engine)
# Ceilometer (metering and monitoring data usage)

# Compute Cluster:
# compute nodes (Nova)

# Storage Cluster:
# storage nodes (Cinder Volume, Swift)

# Other components:
# Fuel (used for deployment of Openstack)
# MySQL database
# Message queueing hosts

# Fuel
fuel node # list the physcial* Openstack hosts with roles and status
fuel node | grep controller # list the Openstack controller nodes
fuel node | grep compute # list the Openstack compute nodes
fuel node | grep ceph # list the Openstack storage (ceph) nodes

# On the Fuel node:
dockerctl list -l # list docker images with details
dockerctl check all # check all docker images

# Kolla
# Is a method of installing Openstack.
# c141 is the name of the Openstack installation here.
# /etc/hosts (host list)
source /etc/kolla/c141/admin-openrc.sh # to run OpenStack commands

# The Orchestration service supports two template formats:
# AWS CloudFormation compatible format (CFN)
# Heat Orchestration Template (HOT)

# Heat can use autoscaling with Celimeter.
# Heat does not track success of failure of VM provisioning,
# but a newer project called Senlin will.

# Configuration is stored in a heat.yaml file.
# These templates are used to create “stacks” which are a collection of resources, such as...
# instances, floating IPs, volumes, security groups, and users.



# Nova

source /home/stack/openrc # source env file
set | grep OS_ # list credentials variables

nova service-list # list nodes, roles, status, state

nova-manage service enable --host=n010.c140.digitalriverws.net --service=nova-compute

nova help # all subcommands for the given command
nova help boot # options for nova boot
nova boot # options for nova boot

nova hypervisor-list # list compute nodes
nova list # list instances
nova list --all-tenants # list instances for all tenants
nova list --host n010.c140.digitalriverws.net --all-tenants # list all instances running on the host
nova hypervisor-servers n010.c140.drws.net # list all instances running on the host
nova show testinstance1 # show info about instance
nova show bc178387-0c00-4d25-89c0-062e1695a986 | grep hypervisor # show where the instance is running

nova image-list # list images
nova image-show cirros-0.3.4-x86_64-uec # show info about the image

nova flavor-list # list the nova flavors
nova flavor-show m1.tiny # show info about he flavor

nova keypair-list # list the ssh keys
ssh-keygen -f /home/stack/ssh-key # create an SSH Key pair
nova keypair-add novakey1 --pub-key /home/stack/ssh-key.pub # add the SSH key to the key store
nova keypair-add novakey1 # create and adds a key to the key store

# Security group commands
nova secgroup-list
nova secgroup-create custom "custom security group"
nova secgroup-add-rule custom tcp 22 22 10.2.0.224/27
nova secgroup-add-rule custom icmp -1 -1 10.2.0.224/27

# Launch an instance, various options
nova boot testinstance1 --flavor m1.tiny --image cirros-0.3.5-x86_64-disk --key-name novakey1
nova boot testinstance1 --flavor m1.tiny --image cirros-0.3.5-x86_64-disk --key-name novakey1 --nic net-name=private
nova boot testinstance1 --flavor m1.tiny --image cirros-0.3.5-x86_64-disk --key-name novakey1 --nic net-id=3f32b422-21c5-41a3-bcdb-3aa280770961
nova boot testinstance1 --flavor m1.tiny --image cirros-0.3.5-x86_64-disk --security-groups default,custom --nic net-name=practice
nova boot testinstance1 --flavor m1.tiny --image cirros-0.3.5-x86_64-disk --nic port-id=3d654b2c-3d57-4f96-803a-96a5d5b57994

nova service-enable n010.c140.drws.net nova-compute # enable compute on the hypervisor
nova service-disable n010.c140.drws.net nova-compute # disable compute on the hypervisor

# Live migrate an instance
nova live-migration bc178387-0c00-4d25-89c0-062e1695a986

nova reset-state --active f6b4cb7d-22dd-44f6-9b76-e9a5ee65c81e

# Delete the instance
nova delete testinstance1

# When an instance is shelved it is shutdown and an image snapshot is created.
# When an instance is unshelved, the image snapshot associated with the instance is automatically deleted by default.

# Locking an instance will prevent any state modifications to the instance.

pcs status # pacemaker/corosync, view current cluster and resource status
rabbitmqctl list_queues name consumers messages | grep -vw "0$"

pcs status
service pacemaker status

pcs resource disable p_ntp
pcs resource enable p_ntp

pcs resource disable p_mysql
pcs resource enable p_mysql
pcs resource clear p_mysql  n013.c140.drws.net
pcs resource ban p_mysql  n012.c140.drws.net

crm resource restart p_mysql
crm resource cleanup p_mysql
crm configure edit p_mysqlq



# Ceph

service ceph status
ceph -s # show cluster status
ceph -w # watch live cluster changes
ceph health detail # health of ceph cluster
ceph df # ceph disk usage
restart ceph-osd id=0 # restart the ceph osd
restart ceph-osd-all # restart all ceph osd's
restart ceph # restart ceph from ceph node
restart ceph-all # restart ceph from the controller nodes
ceph osd tree # output includes osd status, weight, reweight, host, etc.
ceph osd set noout # take the osd out of service, all osd's on a ceph node?
ceph osd unset noout # return the osd to service, all osd's on a ceph node?
ceph osd reweight 40 1 # set osd.40 or reweight value 1
ceph osd pool set images pg_num 1024 # set number of pg's in image pool to 1024
ceph osd pool set images pgp_num 1024 # placement groups for placement, required for rebalancing
ceph osd pool set <pool-name> min_size 2
ceph tell osd.* injectargs '--osd_max_backfills 10'
ceph tell osd.* injectargs '--osd_backfill_full_ratio 0.93'
ceph osd crush reweight osd.<osd-id> <new-weight>
ceph pg 9.28 query # info about the ceph placement group
ceph pg repair 9.23f # repair the pg



# Neutron

neutron net-list # list networks
neutron net-create private2 --shared # create shared network private2

neutron subnet-list # list subnets

# Create a subnet, various options
neutron subnet-create --name private-subnet3 private2 10.0.2.0/26
neutron subnet-create --name practicesubnet --gateway 10.2.0.225 --allocation-pool start=10.2.0.240,end=10.2.0.245 practice 10.2.0.224/27

neutron router-list # list routers

# Create and configure a router
neutron router-create router2
neutron router-gateway-set router2 public
neutron router-interface-add router2 private-subnet2 # add interface - subnet

# Mark down/up a router
neutron router-update Architecture_Router2 --admin-state-up false
neutron router-update Architecture_Router2 --admin-state-up true

# A Neutron Port is a connection point for attaching a single device,
# such as the NIC of a virtual server, to a virtual network.
# The port also describes the associated network configuration,
# such as the MAC and IP addresses to be used on that port.

neutron port-list # list ports

# Create a Neutron port, the net-id is the network id
neutron port-create --fixed-ip subnet_id=af04a24d-e4fb-43d8-a16a-456316460669,ip_address=10.0.0.10 dcfc77e3-641a-41a6-a043-95b68be1f04b

# Delete the port
neutron port-delete 3d654b2c-3d57-4f96-803a-96a5d5b57994

# List floating ip's
neutron floatingip-list

# Create a floating IP in the 'public' network
neutron floatingip-create public

# Associate the floating IP with a port. The parameters are FLOATINGIP_ID and PORT.
neutron floatingip-associate b7376b8b-2f01-47d9-a72a-8af2043ef82b 71d2508c-04de-47c6-9193-3178c57550c6

# Create a load balancer pool
neutron lb-pool-create --name mypool --lb-method ROUND_ROBIN --protocol HTTP --subnet-id af04a24d-e4fb-43d8-a16a-456316460669

# Add members to the pool
neutron lb-member-create mypool --address 10.0.0.18 --protocol-port 80
neutron lb-member-create mypool --address 10.0.0.19 --protocol-port 80

# Create a health-monitor
neutron lb-healthmonitor-create --delay 3 --type HTTP --max-retries 3 --timeout 3

# Associate the health-monitor with the pool
neutron lb-healthmonitor-associate 12e921e6-e60f-4c6d-befb-3eba8d6570f9 mypool

# Create a virtual IP address (VIP) for the pool
neutron lb-vip-create --name myvip --protocol-port 80 --protocol HTTP --subnet-id af04a24d-e4fb-43d8-a16a-456316460669 mypool

# Add a security group rule to allow HTTP connection
neutron security-group-rule-create default --port-range-min 80 --port-range-max 80 --protocol tcp --remote-ip-prefix 172.24.4.0/24

# List the security group rules
neutron security-group-rule-list

# Web server
nohup sudo nc -lk -p 80 -e echo -ne "HTTP/1.0 200 OK\r\nContent-Length: 9\r\n\r\nserver1\r\n" &

# Test the load balancing
watch curl -s http://10.0.0.20

# Delete the VIP
neutron lb-vip-delete myvip

# List the health-monitors
neutron lb-healthmonitor-list

# Delete the load balancer pool:
neutron lb-pool-delete mypool

iptables -nL -t nat

# Namespaces are like chroot's for the  Linux network stack.
ip netns list # view namespaces

# These execute the commands for the specified namespaces
ip netns exec qrouter-7807a603-349f-490c-9e12-5ad3582fe14d ifconfig
ip netns exec qrouter-7807a603-349f-490c-9e12-5ad3582fe14d route -n
ip netns exec qrouter-7807a603-349f-490c-9e12-5ad3582fe14d iptables -nL -t nat

# DHCP in this example runs inside a namespace
ip netns exec qdhcp-559d2dce-aa49-44a7-b7fd-189ab08b6bfa netstat -nap
ps -axf | grep <PID from above output>

# Remove MAC address with virt-sysprep



# Glance

glance image-list # list images

qemu-img info ubuntu1204.img # image info

# Add the Ubuntu qcow2 image to OpenStack using glance client
glance image-create --progress --name Ubuntu1204 --file /home/stack/images/ubuntu1204.img --disk-format qcow2 --container-format bare

# /home/stack/images/ (images)
# /opt/stack/data/glance/cache/ (Glance cache directory)

# Allow only admin to delete images
vi /etc/glance/policy.json
# "delete_image": "role:admin" (Only admin can delete images)
# The glance-api will need to be reloaded with the steps below.

screen -ls
screen -r stack
# Ctrl + a
# Shift + '
# Select the window
# Kill and restart



# Cinder

cinder help create # help commands for cider
cinder list # list volumes

# Allow only admin to create volumes
vi /etc/cinder/policy.json
# “volume:create”: [["role:admin"]],

screen -ls
screen -r stack
# Ctrl + a
# Shift + '
# Select the window
# Kill and restart

cinder create --name pvol 1 # create a 1G volume
nova volume-attach testinstance1 57a5cec9-4504-42b8-997c-a38e5a6b27ff /dev/vdb # attach volume to instance

cat /proc/partitions # check that the volume was attached to the instance

nova volume-detach testinstance1 57a5cec9-4504-42b8-997c-a38e5a6b27ff # detach volume from instance

cinder service-list
cinder service-disable rbd:volumes cinder-volume
mysql -D cinder -e "select * from services" # look for modified_at to identify the id
mysql -D cinder -e "update services set deleted = 1, disabled=1, modified_at=now() where id=12"



# Swift

swift help
swift help upload

# Get summary info for the demo account
swift stat

# Create storage container called 'bootcamp'
swift post bootcamp

# List storage containters
swift list

# Get info
swift stat bootcamp

# Upload a file
swift upload --object-name test.jpg bootcamp /home/stack/files/test.jpg

# List files in the bootcamp container
swift list bootcamp

# Stat the file in the bootcamp container
swift stat --lh bootcamp test.jpg

# The ETag value is the md5sum value for the file
md5sum /home/stack/files/test.jpg

# Download the file
swift download bootcamp test.jpg

# Add metadata to the test.jpg object
swift post --meta Genre:Comedy bootcamp test.jpg

# View the meta data
swift stat bootcamp test.jpg

swift post --meta Color:Blue bootcamp

# Delete the file
swift delete bootcamp test.jpg

# Upload a file in 10M segments
swift upload --object-name test.mov --segment-size 10485760 bootcamp /home/stack/files/test.mov

# Delete the bootcamp_segments container
swift delete bootcamp_segments



# Ceilometer

# List all available meters
ceilometer meter-list

# List of samples for the image meter
ceilometer sample-list -m image

# Consolidated stats for the image meter
ceilometer statistics -m image

# Default pipeline configuration
/etc/ceilometer/pipeline.yaml

# The source of a pipeline is a producer of data.
# The sink of a pipeline is the consumer of data.

# List the meters for the VM (some stats take a few minutes to appear)
ceilometer meter-list -q resource_id=00622f35-b17c-42e8-bd44-665fcbd53d22

# Just the cpu stats
ceilometer sample-list -m cpu -q resource_id=00622f35-b17c-42e8-bd44-665fcbd53d22

# Just the cpu in 1 hour intervals
ceilometer statistics -m cpu_util -p 3600 -q resource_id=00622f35-b17c-42e8-bd44-665fcbd53d22

# Create an alarm based on the upper bound on the CPU utilization
ceilometer alarm-threshold-create --name cpu_high --description 'running hot' -m cpu_util --statistic avg --period 300 --evaluation-periods 3 --comparison-operator gt --threshold 70.0 --alarm-action 'log://' -q resource_id=00622f35-b17c-42e8-bd44-665fcbd53d22

# List alarms
ceilometer alarm-list

# Modify the alarm
ceilometer alarm-update --threshold 75 a15748b7-2077-4f5e-ae04-ba2956a7f0b2

# Alarm history
ceilometer alarm-history a15748b7-2077-4f5e-ae04-ba2956a7f0b2

# Disable the alarm
ceilometer alarm-update --enabled False a15748b7-2077-4f5e-ae04-ba2956a7f0b2

# Delete the alarm
ceilometer alarm-delete a15748b7-2077-4f5e-ae04-ba2956a7f0b2

# Connect to the MongoDB shell for ceilometer
mongo ceilometer
# Query for the oldest metric
# ceilometer:PRIMARY> db.meter.aggregate({$group:{_id:null, oldest: {$min: "$timestamp"}}})



# Python API



#!/usr/bin/env python
#credentials.py
import os

def get_keystone_creds():
    d = {}
    d['username'] = os.environ['OS_USERNAME']
    d['password'] = os.environ['OS_PASSWORD']
    d['auth_url'] = os.environ['OS_AUTH_URL']
    d['tenant_name'] = os.environ['OS_TENANT_NAME']
    return d

def get_nova_creds():
    d = {}
    d['username'] = os.environ['OS_USERNAME']
    d['api_key'] = os.environ['OS_PASSWORD']
    d['auth_url'] = os.environ['OS_AUTH_URL']
    d['project_id'] = os.environ['OS_TENANT_NAME']
    return d


import novaclient.v2.client as nvclient
from credentials import get_nova_creds
creds = get_nova_creds()
nova = nvclient.Client(**creds)

nova.servers.list() # list instances
nova.networks.list() # list networks
nova.flavors.list() # list flavors
nova.images.list() # list images

server = nova.servers.find(name="my-vm") # find a server by name
server.delete() # delete the server

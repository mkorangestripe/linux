# Chef Notes

### Chef

```shell script
chef gem install chef-sugar --version 5.1.8  # install chef-sugar package in chef
chef gem list --local  # list installed gems in chef
```

```shell script
chef-client  # run chef-client
chef-client -W  # why-run mode (dry run)
chef-client -o snow-agent::default  # run the default snow-agent recipe

# Bootstrap chef, with the attributes in the json file, and set the environment.
chef-client -j snow-agent.json --environment prod
```

```shell script
# Interactive chef-shell and connected to Chef Infra Server:
chef-shell -z
node['roles']  # list chef roles

# Run chef code:
chef-shell
recipe_mode
# enter chef code
run_chef
```


### Kitchen

```shell script
kitchen list  # lists instances

chef exec rspec  # runs unit tests, fast

kitchen create node1-centos-7  # start the instance
kitchen verify  # just runs the integration tests
kitchen converge  # does not delete the VM afterwards, does not run the integration tests
kitchen converge default-centos-7  # runs only on the default-centos-7 instance
kitchen test  # destroy -> create -> converge -> verify -> destroy
kitchen destroy  # destroy instance

kitchen diagnose --all  # show diagnostic configuration for all instances

kitchen login default-centos-7  # login to instance
```


### Knife

```shell script
knife ssl fetch  # copy SSL certificates from an HTTPS server to the trusted_certs_dir directory

knife environment show us_prod  # show env info including cookbooks with versions
knife environment show us_prod -F json  # same as above in json

knife cookbook list -a  # list cookbooks with all available versions
knife cookbook show pl_newrelic_wrap  # show all versions of the cookbook

knife search node 'chef_environment:*_dev AND platform:centos*'  # search for dev nodes running centos
knife search node -i 'chef_environment:*_dev AND platform:centos*'  # search & output only node names (id's)

# Search & output only fqdn's:
knife search node 'chef_environment:*_dev AND platform:centos*' 2>&1 | awk -F: '/FQDN/ {print $2}' | sed 's/^[ \t]*//'

knife node show us08dv2sql06  # show node info
knife node show us08dv2sql06 -F json  # show basic node info in json
knife node edit us08dv2sql06  # edit node info
knife node delete us08dv2bld29  # delete the node from Chef

knife status --hide-by-mins 60  # hide nodes with successful chef-client runs within that last 60 minutes.

knife data bag list  # lists all data bags
knife data bag show passwords  # show items in passwords data bag
knife data bag show passwords root_pw  # show root_pw data bag item
knife data bag show passwords root_pw --secret-file ~/.chef/encrypted_data_bag_secret_dev
knife data bag show passwords root_pw --secret-file ~/.chef/encrypted_data_bag_secret_dev -F json

# Delete data bag item:
knife data bag delete passwords root_pw

# Add data bag item:
knife data bag from file passwords root_pw.json --secret-file ~/.chef/encrypted_data_bag_secret_dev

# Edit data bag item:
knife data bag edit -z passwords root_pw --secret-file ~/.chef/encrypted_data_bag_secret_dev
```

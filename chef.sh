# chef
chef gem install chef-sugar --version 5.1.8  # install chef-sugar package in chef
chef gem list --local  # list installed gems in chef


# kitchen
kitchen list  # lists instances

chef exec rspec  # runs unit tests, fast

kitchen verify  # just runs the integration tests
kitchen converge  # does not delete the VM afterwards, does not run the integration tests
kitchen test  # destroy -> create -> converge -> verify -> destroy
kitchen destroy  # destroy instance

kitchen diagnose --all  # show diagnostic configuration for all instances

kitchen login HOSTNAME  # login to instance


# knife
knife data bag list
knife data bag show passwords
knife data bag show passwords root_pw
knife data bag show passwords root_pw --secret-file ~/.chef/encrypted_data_bag_secret_dev
knife data bag show passwords root_pw --secret-file ~/.chef/encrypted_data_bag_secret_dev -F json

Delete data bag item:
knife data bag delete passwords root_pw

Add data bag item:
knife data bag from file passwords root_pw.json --secret-file ~/.chef/encrypted_data_bag_secret_dev

Edit data bag item:
knife data bag edit -z passwords root_pw --secret-file ~/.chef/encrypted_data_bag_secret_dev

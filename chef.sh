kitchen list  # lists instances

kitchen verify  # just runs the integration tests
kitchen converge  # does not delete the VM afterwards, does not run the integration tests
kitchen test  # destroy -> create -> converge -> verify -> destroy
kitchen destroy  # destroy instance

kitchen diagnose --all  # show diagnostic configuration for all instances

kitchen login HOSTNAME  # login to instance

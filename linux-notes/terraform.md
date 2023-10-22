# Terraform

```shell script
terrform fmt        # autoformat terraform scripts
terraform validate  # check and report errors in config
terraform console   # terraform cli
```

```shell script
source ~/.tfvars    # source Terraform input variables
```

```shell script
terraform init      # initialize a working directory containing Terraform configuration files
```

```shell script
terraform plan      # create an execution plan
terraform plan --parallelism=2 --out tf.plan  # create execution plan, limit parallelism, output to file
```

```shell script
terraform apply     # apply changes
terraform apply --parallelism=2 tf.plan  # apply changes, limit parallelism, use plan in file
```

```shell script
terraform show      # show state
terraform destroy   # terminate resources defined in Terraform configuration
```

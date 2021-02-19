# Terraform Notes

```shell script
terrform fmt  # autoformat terraform scripts
terraform validate  # check and report errors in config

source ~/.tfvars  # source Terraform input variables

terraform init  # initialize a working directory containing Terraform configuration files
terraform plan  # create an execution plan
terraform plan --parallelism=2 --out tf.plan  # create execution plan, limit parallelism, output to file
terraform apply  # apply changes
terraform apply --parallelism=2 tf.plan  # apply changes, limit parallelism

terraform show  # show state
terraform destroy  # terminate resources defined in Terraform configuration
```

# AWS CLI Notes

### Configuration

```shell script
# These will prompt for access key, secret key, default region, default output format.
aws configure
aws configure --profile user1
```

### IAM

```shell script
aws iam list-users
```

### VPC

```shell script
aws ec2 describe-vpcs --vpc-ids
aws ec2 describe-vpcs --vpc-ids [VPC ID]
```

### EC2

```shell script
aws ec2 describe-instances
aws ec2 describe-instances --region us-east-1

aws ec2 describe-vpcs
aws ec2 describe-subnets
aws ec2 describe-route-tables
aws ec2 describe-dhcp-options

aws ec2 describe-network-acls
aws ec2 describe-security-groups

```

### ECS

```shell script
aws ecs list-clusters
aws ecs describe-clusters

aws ecs list-services --cluster loadbalancer-app

aws ecs list-tasks --cluster loadbalancer-app
aws ecs list-task-definitions
```

### ECR

```shell script
aws ecr create-repository --repository-name lb-repo      # create a repo
aws ecr get-login --region us-east-1 --no-include-email  # get login info
docker login -u AWS -p [PRIVATE KEY] https://xxxxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com  # get uri from repository['repositoryUri']
```

### Route 53

```shell script
# Create a route53 reusable delegation set.
# This will output a list of nameservers.
aws route53 create-reusable-delegation-set --caller-reference 1224 --profile user1
```

### S3

```shell script
# List bucket contents:
aws s3 ls
aws s3 ls s3://aws-testbucket-2019-05-03

# Create a bucket:
aws s3 mb s3://cda-test-bucket

# Get bucket lifecycle config:
aws s3api get-bucket-lifecycle-configuration --bucket aws-testbucket-2019-05-03

# Put bucket lifecycle config:
aws s3api put-bucket-lifecycle-configuration --bucket aws-testbucket-2019-05-03 --lifecycle-configuration file://policy1.json
```

### DynamoDB

```shell script
# List tables:
aws dynamodb list-tables

# Describe table schema:
aws dynamodb describe-table --table-name Music
```

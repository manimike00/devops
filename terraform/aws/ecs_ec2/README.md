AWS ECS Cluster with EC2 using Terraform

Prerequistes

1. Terraform -> 0.14 >=
2. AWS CLI configured


Steps:

TRUST="{ \"Version\": \"2012-10-17\", \"Statement\": [ { \"Effect\": \"Allow\", \"Principal\": { \"AWS\": \"arn:aws:iam::$(aws sts get-caller-identity --output text | awk {'print $1'}):$(aws sts get-caller-identity --output text | awk '{print $2}' | awk -F '/' '{print $NF}')\" }, \"Action\": \"sts:AssumeRole\" } ] }"

aws iam create-role --role-name EcsCreator --assume-role-policy-document "$TRUST" --output text --query 'Role.Arn'

aws iam put-role-policy --role-name EcsCreator --policy-name eks-describe --policy-document file://$(pwd)/policy.json

1. Export ENV's

    $ export AWS_REGION=ap-south-1
    $ export BUCKETNAME=mmmmnnnncccc

1. Create a S3 bucket for Storing Statefiles

    $ aws s3api create-bucket \
        --bucket $BUCKETNAME \
        --create-bucket-configuration LocationConstraint=$AWS_REGION

AWS ECS Cluster with EC2 using Terraform

Prerequistes

1. Terraform -> 0.14 >=
2. AWS CLI configured


Steps:

1. Export ENV's

    $ export AWS_REGION=ap-south-1
    $ export BUCKETNAME=mmmmnnnncccc

1. Create a S3 bucket for Storing Statefiles

    $ aws s3api create-bucket \
        --bucket $BUCKETNAME \
        --create-bucket-configuration LocationConstraint=$AWS_REGION

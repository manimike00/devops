#### AWS ECS Cluster with EC2 using Terraform

## Prerequistes

1. Terraform -> 0.14 >=
2. AWS CLI configured


Steps:

TRUST="{ \"Version\": \"2012-10-17\", \"Statement\": [ { \"Effect\": \"Allow\", \"Principal\": { \"AWS\": \"arn:aws:iam::$(aws sts get-caller-identity --output text | awk {'print $1'}):$(aws sts get-caller-identity --output text | awk '{print $2}' | awk -F '/' '{print $NF}')\" }, \"Action\": \"sts:AssumeRole\" } ] }"

aws iam create-role --role-name EcsCreator --assume-role-policy-document "$TRUST" --output text --query 'Role.Arn'

aws iam put-role-policy --role-name EcsCreator --policy-name eks-describe --policy-document file://$(pwd)/policy.json

CREDENTIALS=$(aws sts assume-role --role-arn arn:aws:iam::$(aws sts get-caller-identity --output text | awk {'print $1'}):role/EcsCreator --role-session-name codebuild-kubectl --duration-seconds 3600) && \
export AWS_ACCESS_KEY_ID="$(echo ${CREDENTIALS} | jq -r '.Credentials.AccessKeyId')" && \
export AWS_SECRET_ACCESS_KEY="$(echo ${CREDENTIALS} | jq -r '.Credentials.SecretAccessKey')" && \
export AWS_SESSION_TOKEN="$(echo ${CREDENTIALS} | jq -r '.Credentials.SessionToken')" && \
export AWS_EXPIRATION=$(echo ${CREDENTIALS} | jq -r '.Credentials.Expiration')

unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_EXPIRATION

1. Export ENV's

    $ export AWS_REGION=ap-south-1
    $ export BUCKETNAME=mmmmnnnncccc

1. Create a S3 bucket for Storing Statefiles

    $ aws s3api create-bucket \
        --bucket $BUCKETNAME \
        --create-bucket-configuration LocationConstraint=$AWS_REGION

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/manimike00/devops">
    <img src="images/awsecs.png" alt="Logo" width="300" height="200">
  </a>

  <h3 align="center">AWS ECS Cluster with EC2 using Terraform</h3>

  <p align="center">
    An awesome README template to jumpstart your projects!
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template">View Demo</a>
    ·
    <a href="https://github.com/othneildrew/Best-README-Template/issues">Report Bug</a>
    ·
    <a href="https://github.com/othneildrew/Best-README-Template/issues">Request Feature</a>
  </p>
</p>

<!-- GETTING STARTED -->
## Getting Started

This is an example of how you may setting up your AWS ECS cluster using Terraform.
To get cluster up and running follow these steps.

#### Prerequistes

1. Terraform 0.14 >=
2. AWS CLI configured


##### Creating IAM role for ECS Cluster Creation
```
$ TRUST="{ \"Version\": \"2012-10-17\", \"Statement\": [ { \"Effect\": \"Allow\", \"Principal\": { \"AWS\": \"arn:aws:iam::$(aws sts get-caller-identity --output text | awk {'print $1'}):$(aws sts get-caller-identity --output text | awk '{print $2}' | awk -F '/' '{print $NF}')\" }, \"Action\": \"sts:AssumeRole\" } ] }"

$ aws iam create-role --role-name EcsCreator --assume-role-policy-document "$TRUST" --output text --query 'Role.Arn'

$ aws iam put-role-policy --role-name EcsCreator --policy-name eks-describe --policy-document file://$(pwd)/policy.json
```

##### Configuring AWS CLI Access with Session Token
```
$ CREDENTIALS=$(aws sts assume-role --role-arn arn:aws:iam::$(aws sts get-caller-identity --output text | awk {'print $1'}):role/EcsCreator --role-session-name codebuild-kubectl --duration-seconds 3600) && \
  export AWS_ACCESS_KEY_ID="$(echo ${CREDENTIALS} | jq -r '.Credentials.AccessKeyId')" && \
  export AWS_SECRET_ACCESS_KEY="$(echo ${CREDENTIALS} | jq -r '.Credentials.SecretAccessKey')" && \
  export AWS_SESSION_TOKEN="$(echo ${CREDENTIALS} | jq -r '.Credentials.SessionToken')" && \
  export AWS_EXPIRATION=$(echo ${CREDENTIALS} | jq -r '.Credentials.Expiration')
```

##### Environment variables
```
    $ export AWS_REGION=ap-south-1
    $ export BUCKETNAME=myS3Bucket
```
##### Create S3 bucket for Storing Statefiles
```
    $ aws s3api create-bucket \
        --bucket $BUCKETNAME \
        --create-bucket-configuration LocationConstraint=$AWS_REGION
```        

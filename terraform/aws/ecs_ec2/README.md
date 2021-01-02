[contributors-shield]: https://img.shields.io/github/contributors/manimike00/devops.svg?style=for-the-badge
[contributors-url]: https://github.com/manimike00/devops/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/manimike00/devops.svg?style=for-the-badge
[forks-url]: https://github.com/manimike00/devops/network/members
[stars-shield]: https://img.shields.io/github/stars/manimike00/devops.svg?style=for-the-badge
[stars-url]: https://github.com/manimike00/devops/stargazers
[issues-shield]: https://img.shields.io/github/issues/manimike00/devops.svg?style=for-the-badge
[issues-url]: https://github.com/manimike00/devops/issues
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/manikandan-%F0%9F%91%A8%E2%80%8D%F0%9F%92%BB-9a63b1182/

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/manimike00/devops">
    <img src="images/awsecs.png" alt="Logo" width="300" height="200">
  </a>

  <h3 align="center">AWS ECS Cluster using Terraform</h3>

  <p align="center">
    Creating AWS ECS Cluster with EC2 worker nodes using Terraform
    <br />
    <a href="https://github.com/manimike00/devops"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/manimike00/devops">View Demo</a>
    ·
    <a href="https://github.com/manimike00/devops/issues">Report Bug</a>
    ·
    <a href="https://github.com/manimike00/devops/issues">Request Feature</a>
  </p>
</p>

<!-- GETTING STARTED -->
## Getting Started

This is an example of how you create your AWS ECS cluster using Terraform.
To get cluster up and running follow these steps.

#### Prerequisites

1. Terraform 0.14 >=
2. AWS CLI configured


##### Creating IAM role for ECS Cluster Creation
```zsh
TRUST="{ \"Version\": \"2012-10-17\", \"Statement\": [ { \"Effect\": \"Allow\", \"Principal\": { \"AWS\": \"arn:aws:iam::$(aws sts get-caller-identity --output text | awk {'print $1'}):$(aws sts get-caller-identity --output text | awk '{print $2}' | awk -F '/' '{print $NF}')\" }, \"Action\": \"sts:AssumeRole\" } ] }"

aws iam create-role --role-name ecsCreator --assume-role-policy-document "$TRUST" --output text --query 'Role.Arn'

aws iam put-role-policy --role-name ecsCreator --policy-name ecsCreator --policy-document file://$(pwd)/policy.json
```

##### Configuring AWS CLI Access with Session Token
```zsh
CREDENTIALS=$(aws sts assume-role --role-arn arn:aws:iam::$(aws sts get-caller-identity --output text | awk {'print $1'}):role/EcsCreator --role-session-name ecsCreator --duration-seconds 3600) \
&& export AWS_ACCESS_KEY_ID="$(echo ${CREDENTIALS} | jq -r '.Credentials.AccessKeyId')" \
&& export AWS_SECRET_ACCESS_KEY="$(echo ${CREDENTIALS} | jq -r '.Credentials.SecretAccessKey')" \
&& export AWS_SESSION_TOKEN="$(echo ${CREDENTIALS} | jq -r '.Credentials.SessionToken')" \
&& export AWS_EXPIRATION=$(echo ${CREDENTIALS} | jq -r '.Credentials.Expiration')
```

##### Environment variables
```zsh
export AWS_REGION=ap-south-1
export BUCKETNAME=myS3Bucket
```
##### Create S3 bucket for Storing Statefiles
```zsh
aws s3api create-bucket \
    --bucket $BUCKETNAME \
    --create-bucket-configuration LocationConstraint=$AWS_REGION
```        

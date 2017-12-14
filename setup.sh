#!/bin/bash -e

DEFAULT_VPC=$(aws ec2 describe-vpcs --filter Name=isDefault,Values=true --query Vpcs[0].VpcId --output text)
SUBNET=$(aws ec2 describe-subnets --filter Name=vpc-id,Values=$DEFAULT_VPC --query Subnets[0].SubnetId --output text)

#echo "Enter the Stack name:"
#read STACK_NAME
STACK_NAME="newcloud"

#echo "Enter the GitHub repository:"
#read GITHUB_REPO
GITHUB_REPO="newcloud"

#echo "Enter the GitHub owner:"
#read GITHUB_OWNER
GITHUB_OWNER="https://github.com/khoick245"

#echo "Enter the GitHub OAuth Token:"
#read GITHUB_OAUTH_TOKEN
GITHUB_OAUTH_TOKEN="a0a9ee69646adaa7d482e6b62c354a24ace9ec1e"

aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://deploy/stack.yml --parameters ParameterKey=GitHubOwner,ParameterValue=$GITHUB_OWNER ParameterKey=GitHubOAuthToken,ParameterValue=$GITHUB_OAUTH_TOKEN ParameterKey=GitHubRepo,ParameterValue=$GITHUB_REPO ParameterKey=VPC,ParameterValue=$DEFAULT_VPC ParameterKey=Subnet,ParameterValue=$SUBNET --capabilities CAPABILITY_IAM

echo "Creating the CloudFormation stack, this will take a few minutes ..."

aws cloudformation wait stack-create-complete --stack-name $STACK_NAME

echo "Done!"
aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`URL`].OutputValue' --output text
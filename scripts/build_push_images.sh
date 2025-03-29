#!/bin/bash

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="ap-south-1"
REPO_NAME="glps-demo-ecr-repo"

# Login to ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Create repos if not exist
aws ecr describe-repositories --repository-names my-frontend || aws ecr create-repository --repository-name my-frontend
aws ecr describe-repositories --repository-names my-backend || aws ecr create-repository --repository-name my-backend
aws ecr describe-repositories --repository-names my-database || aws ecr create-repository --repository-name my-database

# Build and Push
docker build -t my-frontend ./frontend
docker tag my-frontend:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/my-frontend:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/my-frontend:latest

docker build -t my-backend ./backend
docker tag my-backend:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/my-backend:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/my-backend:latest

docker build -t my-database ./database
docker tag my-database:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/my-database:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/my-database:latest
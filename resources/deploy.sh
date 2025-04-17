#!/bin/bash

REPOSITORY_URL="$1"
AWS_REGION="$2"

# Install Docker
sudo yum update -y
sudo yum install -y docker

# Start Docker service
sudo service docker start

# Give Docker time to start
sleep 10

# Authenticate Docker with ECR
aws ecr get-login-password --region $AWS_REGION | sudo docker login --username AWS --password-stdin $REPOSITORY_URL


# Pull Docker image
sudo docker pull "${REPOSITORY_URL}:latest"

# Stop and remove the existing container
sudo docker stop nodejs-container || true
sudo docker rm nodejs-container || true

# Run the Docker container
sudo docker run -d -p 80:3000 --name nodejs-container "${REPOSITORY_URL}:latest"

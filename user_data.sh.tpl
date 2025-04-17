#!/bin/bash
sudo yum update -y
sudo yum install -y docker aws-cli
sudo service docker start
sleep 45
aws ecr get-login-password --region ${REGION} | sudo docker login --username AWS --password-stdin ${REPOSITORY_URL}
sudo docker pull ${REPOSITORY_URL}:latest
sudo docker run -d -p 80:3000 ${REPOSITORY_URL}

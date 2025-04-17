# AWS EC2 Container Deployment with Terraform and Docker

This project provisions an EC2 instance, configures Docker, and deploys a containerized application from an AWS ECR repository using Terraform and a custom startup script.

---

## 🚀 Project Structure

| File | Description |
|------|-------------|
| `main.tf` | Main Terraform configuration, provisions EC2 and related infrastructure |
| `provider.tf` | Sets up the AWS provider |
| `variables.tf` | Defines input variables for the infrastructure |
| `ecr.tf` | Creates the AWS ECR repository |
| `role.tf` | IAM roles and policies for EC2 to access ECR |
| `user_data.sh.tpl` | EC2 startup script for Docker installation and deployment |
| `deploy.sh` | Helper script to manually deploy/pull Docker image on EC2 |
| `Dockerfile` | Builds the application Docker image |
| `README.md` | Project documentation |

---

## 🧱 Infrastructure Overview

- **EC2 Instance**: Automatically bootstrapped with Docker and your containerized app.
- **ECR Repository**: Hosts your Docker image.
- **IAM Role**: Grants EC2 permission to pull from ECR.
- **User Data Script**: Automates Docker setup and container launch on EC2 instance creation.

---

## 🛠 Usage

### 1. 🧪 Prerequisites

Ensure you have:
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- AWS credentials configured (`~/.aws/credentials`)

### 2. 🏗️ Infrastructure Deployment

```bash
terraform init
terraform plan
terraform apply

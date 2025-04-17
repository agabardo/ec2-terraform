/*
  This Terraform script provisions resources for managing EC2 instances:
  
  1. Creates an RSA private key and saves it to a local file.
  2. Creates an S3 bucket to store the EC2 key pair.
  3. Uploads the private key to an S3 bucket.
  4. Creates a VPC with a specified CIDR block.
  5. Creates an Internet Gateway and attaches it to the VPC.
  6. Creates a Route Table and associates it with the VPC.
  7. Creates a Subnet within the VPC with a specified CIDR block.
  8. Creates a Security Group allowing SSH access from any IP address.
  9. Launches an EC2 Instance within the Subnet, associating the key pair and Security Group.

  Replace variable values as needed for your environment.
*/

# Generate an RSA private key with 4096 bits
resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an EC2 key pair using the generated RSA public key
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.generated_key.public_key_openssh
  tags = {
    "source" = "terraform",
    "environment" = terraform.workspace
  }
}

# Save the private key to a local file
resource "local_file" "private_key_file" {
  filename = "${path.module}/${var.key_filename}"
  content  = tls_private_key.generated_key.private_key_pem
}

# Create an S3 bucket to store the EC2 key pair
resource "aws_s3_bucket" "ec2_key_pair_bucket" {
  bucket = var.bucket_name
  tags = {
    "source" = "terraform",
    "environment" = terraform.workspace
  }
}

# Upload the private key to an S3 bucket
resource "aws_s3_object" "ec2_key_pair_object" {
  bucket = aws_s3_bucket.ec2_key_pair_bucket.id
  key    = var.key_filename
  source = local_file.private_key_file.filename
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Create a Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Create a Subnet
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"
}

# Update the Security Group to allow HTTP traffic on port 80
resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch an EC2 Instance
resource "aws_instance" "ec2instance" {
  ami                         = var.instance
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.main.id
  key_name                    = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  associate_public_ip_address = var.allow_public_ip
  
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  // user_data = data.template_file.user_data.rendered

  tags = {
    Name = var.instance_name,
    "source" = "terraform",
    "environment" = terraform.workspace
  }
}

output "repository_url" {
  value = aws_ecr_repository.ecr_repo.repository_url
}

output "public_ip" {
  value = aws_instance.ec2instance.public_ip
}


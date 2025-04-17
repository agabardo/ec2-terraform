variable "ECR_repository_name" {
  description = "The ECR Repository where the Docker image will be stored"
  default     = "node_js_ec2_repo"
}

variable "region" {
  description = "The AWS region to deploy the EC2 instance"
  default     = "ap-southeast-2"
}

variable "key_name" {
  description = "The name of the EC2 key pair"
  default = "my-ec2-keypair"
}

variable "key_filename" {
  description = "The name of file to store the EC2 key pair"
   default = "my-ec2-keypair.pem"
}

variable "bucket_name" {
  description = "The name of S3 bucket used to store the EC2 key pair file"
  default     = "xxxx129312392xxx-ec2-key-pair-bucket"
}

variable "instance_name" {
  description = "The name that the EC2 instance will be tagged in the AWS panel"
  default = "Node.js EC2 Instance"
}

variable "instance" {
  description = "The EC2 AMI code for the EC2 instance"
  default = "ami-0ec0514235185af79"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  default = "t2.nano"
}

variable "allow_public_ip" {
  description = "Wether or not to allow a public IP to be attributed to the instance"
  default = true
}
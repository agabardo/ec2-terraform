terraform {
  backend "s3" {
    bucket         = "agabardo-terraform-state-bucket"
    key            = "terraform/state.tfstate"
    region         = "ap-southeast-2"
    # dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region  = var.region
}
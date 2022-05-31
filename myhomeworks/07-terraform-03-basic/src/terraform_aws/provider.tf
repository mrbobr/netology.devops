# Configure the AWS Provider + s3 bucket
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
      bucket = "bobrobuck"
      key = "main/config/terraform.tfstate"
      region = "us-west-2"
      dynamodb_table = "tfstate_locks"
  }
}
provider "aws" {}
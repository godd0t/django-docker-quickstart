terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40"
    }
  }


   #state management
  backend "s3" {
    bucket         = "vonq-terraform-infra-state"
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "vonq-terraform-infra-locks"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}
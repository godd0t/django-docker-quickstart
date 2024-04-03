terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40"
}
    }
  }

   #state management
  backend "s3" {
    bucket         = "vonq-terraform-infra-state"
    key            = "staging/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "dml-terraform-infra-locks"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}
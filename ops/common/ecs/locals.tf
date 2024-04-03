locals {
  vpc_id         = data.terraform_remote_state.network.outputs.vpc_id
  client_vpn_sg  = data.terraform_remote_state.network.outputs.vpn_security_group
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_security_group" "public_alb_sg" {
  name   = "tf-${var.environment_name}-public-alb-sg"
  vpc_id = local.vpc_id
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket  = "vonq-terraform-infra-state",
    region  = "eu-central-1",
    key     = "${var.environment_name}/terraform.tfstate"
  }
}

locals {
  vpc_id              = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_one  = data.terraform_remote_state.network.outputs.private_subnet_one
  private_subnet_two  = data.terraform_remote_state.network.outputs.private_subnet_two
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_security_group" "ecs_host_sg" {
  name   = "tf-${var.environment_name}-ecs-host-sg"
  vpc_id = local.vpc_id
}

data "aws_security_group" "client_vpn_sg" {
  name   = "tf-${var.environment_name}-client-vpn-sg"
  vpc_id = local.vpc_id
}

data "aws_ssm_parameter" "database_name" {
  name = "/${var.environment_name}/${var.service_name}/database/name"
}

data "aws_ssm_parameter" "database_username" {
  name = "/${var.environment_name}/${var.service_name}/database/username"
}

data "aws_ssm_parameter" "database_password" {
  name = "/${var.environment_name}/${var.service_name}/database/password"
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket  = "vonq-terraform-infra-state",
    region  = "eu-central-1",
    key     = "${var.environment_name}/terraform.tfstate"
  }
}

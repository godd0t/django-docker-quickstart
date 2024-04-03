locals {
  vpc_id                  = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_one      = data.terraform_remote_state.network.outputs.private_subnet_one
  private_subnet_two      = data.terraform_remote_state.network.outputs.private_subnet_two

  ecs_cluster             = data.terraform_remote_state.ecs.outputs.ecs_cluster_name
  ecs_task_execution_role = data.terraform_remote_state.ecs.outputs.ecs_task_execution_role
  ecs_task_role           = data.terraform_remote_state.ecs.outputs.ecs_task_role
}



data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_security_group" "ecs_host_sg" {
  name   = "tf-${var.environment_name}-ecs-host-sg"
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

data "terraform_remote_state" "ecs" {
  backend = "s3"

  config = {
    bucket  = "vonq-terraform-infra-state",
    region  = "eu-central-1",
    key     = "${var.environment_name}/terraform.tfstate"
  }
}
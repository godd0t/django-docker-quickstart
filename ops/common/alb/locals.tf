locals {
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_one  = data.terraform_remote_state.network.outputs.public_subnet_one
  public_subnet_two  = data.terraform_remote_state.network.outputs.public_subnet_two
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket  = "vonq-terraform-infra-state",
    region  = "eu-central-1",
    key     = "${var.environment_name}/terraform.tfstate"
  }
}

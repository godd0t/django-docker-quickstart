resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/ecs/${var.environment_name}/backend"
  retention_in_days = 7

  tags = {
    Name = "tf-ecs-service-log-group"
  }
}

module "backend" {
  source                  = "./backend"
  environment_name        = var.environment_name
  log_group               = aws_cloudwatch_log_group.log_group.name

  subnet_ids              = [local.private_subnet_one, local.private_subnet_two]
  vpc_id                  = local.vpc_id

  ecs_cluster             = local.ecs_cluster
  ecs_host_sg             = data.aws_security_group.ecs_host_sg.id
  ecs_task_execution_role = local.ecs_task_execution_role
  ecs_task_role           = local.ecs_task_role

  region_name             = data.aws_region.current.name
  account_id              = data.aws_caller_identity.current.id
  container_port          = 8000

}

module "worker" {
  source                  = "./worker"
  environment_name        = var.environment_name
  log_group               = aws_cloudwatch_log_group.log_group.name

  subnet_ids              = [local.private_subnet_one, local.private_subnet_two]
  vpc_id                  = local.vpc_id

  ecs_cluster             = local.ecs_cluster
  ecs_host_sg             = data.aws_security_group.ecs_host_sg.id
  ecs_task_execution_role = local.ecs_task_execution_role
  ecs_task_role           = local.ecs_task_role

  region_name             = data.aws_region.current.name
  account_id              = data.aws_caller_identity.current.id

  depends_on = [
    module.backend
  ]
}

module "beat" {
  source                  = "./beat"
  environment_name        = var.environment_name
  log_group               = aws_cloudwatch_log_group.log_group.name

  subnet_ids              = [local.private_subnet_one, local.private_subnet_two]
  vpc_id                  = local.vpc_id

  ecs_cluster             = local.ecs_cluster
  ecs_host_sg             = data.aws_security_group.ecs_host_sg.id
  ecs_task_execution_role = local.ecs_task_execution_role
  ecs_task_role           = local.ecs_task_role

  region_name             = data.aws_region.current.name
  account_id              = data.aws_caller_identity.current.id

  depends_on = [
    module.backend
  ]
}
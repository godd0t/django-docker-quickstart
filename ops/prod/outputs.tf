output "vpc_id" {
  description = "The ID of the VPC that this stack is deployed in"
  value       = module.network.vpc_id
}

output "public_subnet_one" {
  description = "Public subnet one"
  value       = module.network.public_subnet_one
}

output "public_subnet_two" {
  description = "Public subnet two"
  value       = module.network.public_subnet_two
}

output "private_subnet_one" {
  description = "Private subnet one"
  value       = module.network.private_subnet_one
}

output "private_subnet_two" {
  description = "Private subnet two"
  value       = module.network.private_subnet_two
}

output "vpn_security_group" {
  description = "A security group used to allow private resources to receive traffic from VPN"
  value       = module.network.vpn_security_group
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs.ecs_cluster_name
}

output "ecs_host_security_group" {
  description = "A security group used to allow containers to receive traffic"
  value       = module.ecs.ecs_host_security_group
}

output "ecs_role" {
  description = "The ARN of the ECS role."
  value       = module.ecs.ecs_role
}

output "ecs_task_execution_role" {
  description = "Role used by the tasks on the ECS themselves."
  value       = module.ecs.ecs_task_execution_role_arn
}

output "ecs_task_role" {
  description = "Role used by the tasks on the ECS themselves."
  value       = module.ecs.ecs_task_role_arn
}
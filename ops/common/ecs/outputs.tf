output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_host_security_group" {
  description = "A security group used to allow containers to receive traffic"
  value       = aws_security_group.ecs_host_security_group.id
}

output "ecs_role" {
  description = "The ARN of the ECS role."
  value       = aws_iam_role.ecs_role.arn
}

output "ecs_task_execution_role_arn" {
  description = "Role used by the tasks on the ECS themselves."
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "Role used by the tasks on the ECS themselves."
  value       = aws_iam_role.ecs_task_role.arn
}

output "ecs_role_for_code_deploy" {
  description = "Role used by CodeDeploy during blue/green deployments."
  value       = aws_iam_role.ecs_code_deploy_role.arn
}

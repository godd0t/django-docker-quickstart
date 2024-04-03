variable environment_name {
  description = "The name of the environment to add this service to"
  type        = string
  default     = "dev"
}

# ECS Parameters
variable ecs_cluster {
  description = "The name of the ECS cluster"
  type        = string
}

variable ecs_host_sg {
  description = "A security group used to allow containers to receive traffic"
  type        = string
}

variable ecs_task_execution_role {
  description = "Role used by the tasks on the ECS themselves."
  type        = string
}

variable ecs_task_role {
  description = "Role used by the tasks on the ECS themselves."
  type        = string
}

# VPC Parameters
variable vpc_id {
  description = "The id of the vpc you want to deploy this stack in"
  type        = string
}

variable subnet_ids {
  description = "The subnets ids where you want to deploy this stack in"
  type        = list(string)
}

# AWS Parameters

variable account_id{
  description = "The account id where to deploy this service"
  type        = string
}

variable region_name {
  description = "The region name where to deploy this service"
  type        = string
}

# Service Parameters
variable log_group {
  description = "The name of the CloudWatch log group"
  type        = string
  default     = "dev"
}

variable image_tag {
  description = "The tag of the image you want to use"
  type        = string
  default     = "latest"
}

variable container_cpu {
  description = "How much CPU to give the container. 1024 is 1 CPU"
  type        = string
  default     = 512
}

variable container_memory {
  description = "How much memory in megabytes to give the container"
  type        = string
  default     = 1024
}

variable deployment_controller {
  description = "The deployment controller type to use with this service"
  type        = string
  default     = "ECS"
}

variable desired_count {
  description = "How many copies of the service task to run"
  type        = string
  default     = 1
}

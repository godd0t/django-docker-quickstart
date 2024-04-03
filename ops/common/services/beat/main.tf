resource "aws_ecs_task_definition" "task_definition" {
  family                    = "${var.environment_name}-backend-beat"
  network_mode              = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu                       = var.container_cpu
  memory                    = var.container_memory
  execution_role_arn        = var.ecs_task_execution_role
  task_role_arn             = var.ecs_task_role

  container_definitions = jsonencode([
    {
      name         = "${var.environment_name}-backend-beat"
      image        = join("/", ["${var.account_id}.dkr.ecr.${var.region_name}.amazonaws.com", "django-docker-quickstart:${var.image_tag}"])
      command      = ["celery", "-A" ,"quickstart", "beat", "-l", "info"]
      environment = [
        {
          name  = "APP_ENV"
          value = var.environment_name
        },
        {
          name  = "APP_NAME"
          value = "quickstart"
        },
        {
          name  = "APP_HOST"
          value = "0.0.0.0"
        },
        {
          name  = "APP_PORT"
          value = "8000"
        }
      ]
      secrets = [
        {
          name      = "SECRET_KEY"
          valueFrom = "arn:aws:ssm:${var.region_name}:${var.account_id}:parameter/${var.environment_name}/backend/secret"
        },
        {
          name      = "ALLOWED_HOSTS"
          valueFrom = "arn:aws:ssm:${var.region_name}:${var.account_id}:parameter/${var.environment_name}/backend/allowed-hosts"
        },
        {
          name      = "CSRF_TRUSTED_ORIGINS"
          valueFrom = "arn:aws:ssm:${var.region_name}:${var.account_id}:parameter/${var.environment_name}/backend/csrf-trusted-origins"
        },
        {
          name      = "CORS_ALLOWED_ORIGINS"
          valueFrom = "arn:aws:ssm:${var.region_name}:${var.account_id}:parameter/${var.environment_name}/backend/cors-allowed-origins"
        },
        {
          name      = "POSTGRES_HOST"
          valueFrom = "arn:aws:ssm:${var.region_name}:${var.account_id}:parameter/${var.environment_name}/backend/database/host"
        },
        {
          name      = "POSTGRES_DB"
          valueFrom = "arn:aws:ssm:${var.region_name}:${var.account_id}:parameter/${var.environment_name}/backend/database/name"
        },
        {
          name      = "POSTGRES_PASSWORD"
          valueFrom = "arn:aws:ssm:${var.region_name}:${var.account_id}:parameter/${var.environment_name}/backend/database/password"
        },
        {
          name      = "POSTGRES_USER"
          valueFrom = "arn:aws:ssm:${var.region_name}:${var.account_id}:parameter/${var.environment_name}/backend/database/username"
        },
        {
          name      = "REDIS_HOST"
          valueFrom = "arn:aws:ssm:${var.region_name}:${var.account_id}:parameter/${var.environment_name}/backend/cache/host"
        }
      ]
      LogConfiguration = {
        LogDriver = "awslogs"
        Options = {
          awslogs-group         = var.log_group
          awslogs-create-group  = "true"
          awslogs-region        = var.region_name
          awslogs-stream-prefix = "beat"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "service" {
  name                   = "${var.environment_name}-backend-beat"
  cluster                = var.ecs_cluster
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  enable_execute_command = true
  task_definition        = aws_ecs_task_definition.task_definition.arn

  deployment_controller {
    type = var.deployment_controller
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = [var.ecs_host_sg]
    subnets          = var.subnet_ids
  }
}



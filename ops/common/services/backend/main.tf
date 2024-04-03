resource "aws_ecs_task_definition" "task_definition" {
  family                    = "${var.environment_name}-backend"
  network_mode              = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu                       = var.container_cpu
  memory                    = var.container_memory
  execution_role_arn        = var.ecs_task_execution_role
  task_role_arn             = var.ecs_task_role

  container_definitions = jsonencode([
    {
      name         = "${var.environment_name}-backend"
      image        = join("/", ["${var.account_id}.dkr.ecr.${var.region_name}.amazonaws.com", "django-docker-quickstart:${var.image_tag}"])
      portMappings = [
        {
          containerPort = var.container_port
        }
      ]
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
          awslogs-stream-prefix = "backend"
        }
      }
    }
  ])
}

resource "aws_service_discovery_service" "private_service_discovery" {
  name        = "backend"
  description = "Service discovery for ${var.environment_name}-backend"

  dns_config {

    dns_records {
      type = "A"
      ttl = 60
    }

    routing_policy = "MULTIVALUE"
    namespace_id   = data.aws_service_discovery_dns_namespace.private_service_discovery_namespace.id
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

# The service. The service is a resource which allows you to run multiple copies of a type of task,
# and gather up their logs and metrics, as well as monitor the number of running tasks and replace any that have crashed
resource "aws_ecs_service" "service" {
  name                   = "${var.environment_name}-backend"
  cluster                = var.ecs_cluster
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  enable_execute_command = true
  task_definition        = aws_ecs_task_definition.task_definition.arn

  deployment_controller {
    type = var.deployment_controller
  }

  service_registries {
      container_name = "${var.environment_name}-backend"
      registry_arn   = aws_service_discovery_service.private_service_discovery.arn
  }

  load_balancer {
      container_name   = "${var.environment_name}-backend"
      container_port   = var.container_port
      target_group_arn = aws_lb_target_group.http_target_group_one.arn
    }

  network_configuration {
    assign_public_ip = false
    security_groups  = [var.ecs_host_sg]
    subnets          = var.subnet_ids
  }

  depends_on = [
    aws_service_discovery_service.private_service_discovery
  ]
}

resource "aws_lb_target_group" "http_target_group_one" {
  name        = "tf-${var.environment_name}-backend-tg-one"
  protocol    = "HTTP"
  port        = var.container_port
  target_type = "ip"

  health_check {
    interval            = 100
    protocol            = "HTTP"
    path                = var.health_check_endpoint
    timeout             = 60
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  vpc_id = var.vpc_id
}

resource "aws_lb_target_group" "http_target_group_two" {
  name        = "tf-${var.environment_name}-backend-tg-two"
  protocol    = "HTTP"
  port        = var.container_port
  target_type = "ip"

  health_check {
    interval            = 100
    protocol            = "HTTP"
    path                = var.health_check_endpoint
    timeout             = 60
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  vpc_id = var.vpc_id
}

resource "aws_lb_listener_rule" "forward_target_rule" {
  listener_arn      = data.aws_lb_listener.http_listener.arn

  priority = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http_target_group_one.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
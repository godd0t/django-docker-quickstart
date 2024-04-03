# This is an IAM role which authorizes ECS to manage resources on your account on your behalf, such as updating your
# load balancer with the details of where your containers are, so that traffic can reach your containers.
resource "aws_iam_role" "ecs_role" {
  name = "tf-${var.environment_name}-ecs-role"
  path = "/"

  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name   = "ecs-service"
    policy = jsonencode({
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ec2:AttachNetworkInterface",
            "ec2:CreateNetworkInterface",
            "ec2:CreateNetworkInterfacePermission",
            "ec2:DeleteNetworkInterface",
            "ec2:DeleteNetworkInterfacePermission",
            "ec2:Describe*",
            "ec2:DetachNetworkInterface",
            "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
            "elasticloadbalancing:DeregisterTargets",
            "elasticloadbalancing:Describe*",
            "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
            "elasticloadbalancing:RegisterTargets"
          ]
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "tf-${var.environment_name}-ecs-task-execution-role"
  path = "/"

  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name   = "ecs-Logs"
    policy = jsonencode({
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup"
          ]
          Resource = "*"
        }
      ]
    })
  }

  inline_policy {
    name   = "ecs-SSM"
    policy = jsonencode({
      Statement = [
        {
          Sid    = "ReadEnvironmentParameters"
          Effect = "Allow"
          Action = [
            "ssm:GetParameters"
          ]
          Resource = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.environment_name}/*"
        }
      ]
    })
  }

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

resource "aws_iam_role" "ecs_task_role" {
  name = "tf-${var.environment_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name   = "task-ssm"
    policy = jsonencode({
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
          ]
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_iam_role" "ecs_code_deploy_role" {
  name        = "tf-${var.environment_name}-ecs-code-deploy-role"
  description = "Role used by CodeDeploy during blue/green deployments for ${var.environment_name} environment"
  path        = "/"

  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name   = "passRoleForCodeDeploy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = "iam:PassRole"
          Resource = aws_iam_role.ecs_task_execution_role.arn
        }
      ]
    })
  }

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  ]
}
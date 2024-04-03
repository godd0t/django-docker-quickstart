resource "aws_ecs_cluster" "ecs_cluster" {
  name = "tf-${var.environment_name}-cluster"

  tags = {
    Name        = "tf-${var.environment_name}-cluster"
    Environment = var.environment_name
  }
}

resource "aws_security_group" "ecs_host_security_group" {
  name        = "tf-${var.environment_name}-ecs-host-sg"
  description = "Access to the ECS hosts that run containers"
  vpc_id      = local.vpc_id

  egress {
    description  = "Allow all outbound traffic by default"
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "tf-${var.environment_name}-ecs-host-sg"
    Environment = var.environment_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs_security_group_ingress_from_public_alb" {
  description                  = "Ingress from the public ALB"
  security_group_id            = aws_security_group.ecs_host_security_group.id
  ip_protocol                  = -1
  referenced_security_group_id = data.aws_security_group.public_alb_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "ecs_security_group_ingress_from_self" {
  description                  = "Ingress from other containers in the same security group"
  security_group_id            = aws_security_group.ecs_host_security_group.id
  ip_protocol                  = -1
  referenced_security_group_id = aws_security_group.ecs_host_security_group.id
}

resource "aws_vpc_security_group_ingress_rule" "ecs_security_group_ingress_from_vpn" {
  description                  = "Ingress from VPN client endpoint"
  security_group_id            = aws_security_group.ecs_host_security_group.id
  ip_protocol                  = -1
  referenced_security_group_id = local.client_vpn_sg
}

resource "aws_service_discovery_private_dns_namespace" "private_service_discovery_namespace" {
  name = "${var.environment_name}.vonq.internal"
  vpc  = local.vpc_id
}
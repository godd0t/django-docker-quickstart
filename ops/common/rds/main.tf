resource "aws_db_instance" "database_instance" {
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false
  backup_retention_period     = var.db_backup_retention_period
  identifier                  = "tf-${var.environment_name}-${var.service_name}-db"
  db_name                     = data.aws_ssm_parameter.database_name.value
  engine                      = "postgres"
  engine_version              = var.db_engine_version
  username                    = data.aws_ssm_parameter.database_username.value
  password                    = data.aws_ssm_parameter.database_password.value
  instance_class              = var.db_class
  multi_az                    = var.db_multi_az
  backup_window               = var.db_preferred_backup_window
  allocated_storage           = var.db_allocated_storage
  db_subnet_group_name        = aws_db_subnet_group.database_subnet_group.name
  storage_encrypted           = true
  storage_type                = "gp2"
  vpc_security_group_ids      = [aws_security_group.database_access_security_group.id]
}

resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "tf-${var.environment_name}-${var.service_name}-db-subnet-group"
  description = "VPC Subnets for DB"
  subnet_ids  = [
    local.private_subnet_one,
    local.private_subnet_two
  ]

  tags = {
    Name        = "tf-${var.environment_name}-${var.service_name}-db-subnet-group"
    Environment = var.environment_name
  }
}

resource "aws_security_group" "database_access_security_group" {
  name        = "tf-${var.environment_name}-${var.service_name}-db-sg"
  description = "Database access"
  vpc_id      = local.vpc_id

  egress {
    description  = "Allow all outbound traffic by default"
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-${var.environment_name}-${var.service_name}-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "database_access_ingress_from_vpn_ecs" {
  description                  = "Ingress from hosts which run the ECS"
  security_group_id            = aws_security_group.database_access_security_group.id
  ip_protocol                  = -1
  referenced_security_group_id = data.aws_security_group.ecs_host_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "database_access_ingress_from_vpn" {
  description                  = "Ingress from VPN client endpoint"
  security_group_id            = aws_security_group.database_access_security_group.id
  ip_protocol                  = -1
  referenced_security_group_id = data.aws_security_group.client_vpn_sg.id
}

resource "aws_cloudwatch_metric_alarm" "database_cpu_alarm" {
  count               = var.db_alert_sns_topic_arn != "" ? 1 : 0

  alarm_name          = "tf-${var.environment_name}-${var.service_name}-cpu-alarm"
  alarm_description   = "CPU Utilization on RDS Instance is too high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions       = [var.db_alert_sns_topic_arn]
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 60
  unit                = "Percent"
  dimensions = {
      DBInstanceIdentifier = aws_db_instance.database_instance.address
  }
}

resource "aws_cloudwatch_metric_alarm" "database_free_storage_alarm" {
  count               = var.db_alert_sns_topic_arn != "" ? 1 : 0

  alarm_name          = "tf-${var.environment_name}-${var.service_name}-free-storage-alarm"
  alarm_description   = "2Gb left of storage available on RDS Instance"
  comparison_operator = "LessThanOrEqualToThreshold"
  alarm_actions       = [var.db_alert_sns_topic_arn]
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Maximum"
  threshold           = 2147483648
  unit                = "Bytes"
  dimensions = {
      DBInstanceIdentifier = aws_db_instance.database_instance.address
  }

}


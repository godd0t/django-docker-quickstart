

resource "aws_elasticache_cluster" "this" {
  cluster_id          = "tf-${var.environment_name}-${var.service_name}-cache-cluster"
  engine              = "redis"
  node_type           = var.cache_class
  num_cache_nodes     = var.cache_num_nodes
  engine_version      = var.cache_engine_version
  port                = 6379

  subnet_group_name   = aws_elasticache_subnet_group.cache_subnet_group.name
  security_group_ids  = [aws_security_group.cache_access_security_group.id]

  tags = {
    Name        = "tf-${var.environment_name}-${var.service_name}-cache-cluster"
    Environment = var.environment_name
  }
}

resource "aws_elasticache_subnet_group" "cache_subnet_group" {
  name        = "tf-${var.environment_name}-${var.service_name}-cache-subnet-group"
  description = "VPC Subnets for Cache"
  subnet_ids  = [
    local.private_subnet_one,
    local.private_subnet_two
  ]

  tags = {
    Name        = "tf-${var.environment_name}-${var.service_name}-cache-subnet-group"
    Environment = var.environment_name
  }
}

resource "aws_security_group" "cache_access_security_group" {
  name        = "tf-${var.environment_name}-${var.service_name}-cache-sg"
  description = "Cache access"
  vpc_id      = local.vpc_id

  egress {
    description  = "Allow all outbound traffic by default"
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "tf-${var.environment_name}-${var.service_name}-cache-sg"
    Environment = var.environment_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "cache_access_ingress_from_vpn_ecs" {
  description                  = "Ingress from hosts which run the ECS"
  security_group_id            = aws_security_group.cache_access_security_group.id
  ip_protocol                  = -1
  referenced_security_group_id = data.aws_security_group.ecs_host_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "cache_access_ingress_from_vpn" {
  description                  = "Ingress from VPN client endpoint"
  security_group_id            = aws_security_group.cache_access_security_group.id
  ip_protocol                  = -1
  referenced_security_group_id = data.aws_security_group.client_vpn_sg.id
}

resource "aws_cloudwatch_metric_alarm" "cache_cpu_alarm" {
  count               = var.cache_alert_sns_topic_arn != "" ? 1 : 0

  alarm_name          = "tf-${var.environment_name}-${var.service_name}-cache-cluster-cpu-alarm"
  alarm_description   = "CPU Utilization on Cache Instance is too high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions       = [var.cache_alert_sns_topic_arn]
  evaluation_periods  = 1
  metric_name         = "EngineCPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  unit                = "Percent"
  dimensions = {
      CacheClusterId = aws_elasticache_cluster.this.id
  }
}

resource "aws_cloudwatch_metric_alarm" "cache_free_storage_alarm" {
  count               = var.cache_alert_sns_topic_arn != "" ? 1 : 0

  alarm_name          = "tf-${var.environment_name}-${var.service_name}-cache-cluster-cpu-alarm-free-storage-alarm"
  alarm_description   = "Cache instance storage capacity almost full"
  comparison_operator = "GreaterThanThreshold"
  alarm_actions       = [var.cache_alert_sns_topic_arn]
  evaluation_periods  = 1
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Maximum"
  threshold           = 90
  unit                = "Percent"
  dimensions = {
      CacheClusterId = aws_elasticache_cluster.this.id
  }
}

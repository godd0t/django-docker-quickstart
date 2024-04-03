variable environment_name {
  default = "dev"
  type    = string
}

variable service_name {
  description = "The name of the CSM project for which to create the service"
  type        = string
}

# Cache
variable cache_class {
  description = "Cache instance class"
  type        = string
  default     = "cache.t3.medium"
}

variable cache_engine_version {
  description = "Cache engine version"
  type        = string
  default     = "7.0"
}

variable cache_num_nodes {
  description = "The initial number of cache nodes that the cluster has."
  type        = number
  default     = 1
}

# Monitoring
variable cache_alert_sns_topic_arn {
  description = "Alert Notification SNS Topic ARN for ElastiCache."
  type        = string
  default     = ""
}
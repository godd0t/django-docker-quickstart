variable environment_name {
  default = "dev"
  type    = string
}

variable service_name {
  description = "The name of the CSM project for which to create the service"
  type        = string
}

# Database
variable db_class {
  description = "Database instance class"
  type        = string
  default     = "db.m1.small"
}

variable db_engine_version {
  description = "Database engine version"
  type        = string
  default     = "14"
}

variable db_allocated_storage {
  description = "The size of the database (Gb)"
  type        = string
  default     = "5"
}

variable db_multi_az {
  description = "Enable Multi Availability Zones for db instance"
  type        = bool
  default     = false
}

# Backup Settings
variable db_backup_retention_period {
  description = "Backup Retention Period in Days"
  type        = string
  default     = 7
}

variable db_preferred_backup_window {
  description = "Preferred Backup Window Time for snapshot generation (UTC)"
  type        = string
  default     = "23:00-00:00"
}

# Monitoring
variable db_alert_sns_topic_arn {
  description = "Alert Notification SNS Topic ARN for RDS."
  type        = string
  default     = ""
}

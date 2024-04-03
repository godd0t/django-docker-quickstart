output "db_name" {
  description = "The name of the database cluster"
  value       = aws_db_instance.database_instance.address
}

output "db_endpoint_address" {
  value = aws_db_instance.database_instance.address
}

output "db_endpoint_port" {
  value = aws_db_instance.database_instance.port
}

output "db_security_group_id" {
  value = aws_security_group.database_access_security_group.arn
}

#output "db_cpu_alarm" {
#  description = "CPU Alarm Created for RDS Instance/s."
#  value       = aws_cloudwatch_metric_alarm.database_cpu_alarm[count.index].arn
#}
#
#output "db_free_storage_space_alarm" {
#  description = "Disk Free Space Alarm Created for RDS Instance/s."
#  value       = aws_cloudwatch_metric_alarm.database_free_storage_alarm[count.index].arn
#}

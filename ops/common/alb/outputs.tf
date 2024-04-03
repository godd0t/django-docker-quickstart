output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.this.arn
}

output "alb_dns" {
  description = "DNS Name of the Application Load Balancer"
  value       = aws_lb.this.dns_name
}

output "alb_security_group" {
  description = "A security group used to allow alb to receive traffic"
  value       = aws_security_group.alb_security_group.arn
}

output "alb_http_listener_arn" {
  description = "The ARN of the HTTP Listener"
  value       = aws_lb_listener.http_listener.arn
}

data "aws_service_discovery_dns_namespace" "private_service_discovery_namespace" {
  name = "${var.environment_name}.vonq.internal"
  type = "DNS_PRIVATE"
}

data "aws_lb" "public_alb" {
  name = "tf-${var.environment_name}-public-alb"
}

data "aws_lb_listener" "http_listener"{
  load_balancer_arn = data.aws_lb.public_alb.arn
  port              = 80
}
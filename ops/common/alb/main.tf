
resource "aws_lb" "this" {
  name               = "tf-${var.environment_name}-public-alb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    local.public_subnet_one,
    local.public_subnet_two
  ]

  security_groups = [aws_security_group.alb_security_group.id]

  tags = {
    Name        = "tf-${var.environment_name}-public-alb"
    Environment = var.environment_name
  }
}

resource "aws_security_group" "alb_security_group" {
  name        = "tf-${var.environment_name}-public-alb-sg"
  description = "Access to the public facing load balancer"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow all inbound traffic by default"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description  = "Allow all outbound traffic by default"
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "tf-${var.environment_name}-public-alb-sg"
    Environment = var.environment_name
  }
}

resource "aws_lb_listener" "http_listener" {
  depends_on = [
    aws_lb.this
  ]

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "You've reached the listener! Congrats!"
      status_code = "200"
    }
  }

  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"
}
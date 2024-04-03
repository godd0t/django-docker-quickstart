# Setup VPN resources for accessing private subnets.
resource "aws_security_group" "vpn_security_group" {
  name        = "tf-${var.environment_name}-client-vpn-sg"
  description = "Security group for VPN endpoint"
  vpc_id      = aws_vpc.this.id

  egress {
    description = "Allow all outbound traffic by default"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-${var.environment_name}-client-vpn-sg"
  }
}

resource "aws_cloudwatch_log_group" "client_vpn_endpoint_logs_group" {
  name              = "/vpn/${var.environment_name}/access"
  retention_in_days = 90
}

resource "aws_ec2_client_vpn_endpoint" "client_vpn_endpoint" {
  description            = "Client VPN Endpoint"
  server_certificate_arn = "arn:aws:acm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:certificate/${var.vpn_server_certificate_id}"
  client_cidr_block      = local.mappings["SubnetConfig"]["Client"]["CIDR"]
  split_tunnel           = true
  transport_protocol     = "udp"
  vpc_id                 = aws_vpc.this.id
  vpn_port               = 443

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = "arn:aws:acm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:certificate/${var.vpn_client_certificate_id}"
  }

  connection_log_options {
    enabled              = true
    cloudwatch_log_group = aws_cloudwatch_log_group.client_vpn_endpoint_logs_group.name
  }

  dns_servers = [
    local.mappings["SubnetConfig"]["VPCDnsServer"]["IP"]
  ]

  security_group_ids = [
    aws_security_group.vpn_security_group.id
  ]

  tags = {
    Name = "tf-${var.environment_name}-client-vpn"
  }
}

resource "aws_ec2_client_vpn_network_association" "egress_vpc_subnet_one_association" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id
  subnet_id              = aws_subnet.private_subnet_one.id
}

resource "aws_ec2_client_vpn_network_association" "egress_vpc_subnet_two_association" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id
  subnet_id              = aws_subnet.private_subnet_two.id
}

resource "aws_ec2_client_vpn_authorization_rule" "authorise_vpc_rule" {
  description            = "Authorise VPC CIDR"
  authorize_all_groups   = true
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id
  target_network_cidr    = local.mappings["SubnetConfig"]["VPC"]["CIDR"]
}

resource "aws_ec2_client_vpn_authorization_rule" "authorise_internet_rule" {
  description            = "Authorise connections from Internet"
  authorize_all_groups   = true
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id
  target_network_cidr    = local.mappings["SubnetConfig"]["Internet"]["CIDR"]
}
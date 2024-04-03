output "vpc_id" {
  description = "The ID of the VPC that this stack is deployed in"
  value       = aws_vpc.this.id
}

output "public_subnet_one" {
  description = "Public subnet one"
  value       = aws_subnet.public_subnet_one.id
}

output "public_subnet_two" {
  description = "Public subnet two"
  value       = aws_subnet.public_subnet_two.id
}

output "private_subnet_one" {
  description = "Private subnet one"
  value       = aws_subnet.private_subnet_one.id
}

output "private_subnet_two" {
  description = "Private subnet two"
  value       = aws_subnet.private_subnet_two.id
}

output "private_route_table_one" {
  description = "Private route table one"
  value       = aws_route_table.private_route_table_one.id
}

output "private_route_table_two" {
  description = "Private subnet two"
  value       = aws_route_table.private_route_table_two.id
}

output "vpn_security_group" {
  description = "A security group used to allow private resources to receive traffic from VPN"
  value       = aws_security_group.vpn_security_group.id
}
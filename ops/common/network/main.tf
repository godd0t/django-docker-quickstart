# VPC in which containers will be networked. It has two public subnets, and two private subnets.
# We distribute the subnets across the first two available subnets for the region, for high availability.
resource "aws_vpc" "this" {
  cidr_block           = local.mappings["SubnetConfig"]["VPC"]["CIDR"]
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf-${var.environment_name}-vpc"
  }
}

resource "aws_subnet" "public_subnet_one" {
  availability_zone       = element(data.aws_availability_zones.available.names, 0)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = local.mappings["SubnetConfig"]["PublicOne"]["CIDR"]
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-${var.environment_name}-public-subnet-one"
    Type = "public"
  }
}

resource "aws_subnet" "public_subnet_two" {
  availability_zone       = element(data.aws_availability_zones.available.names, 1)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = local.mappings["SubnetConfig"]["PublicTwo"]["CIDR"]
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-${var.environment_name}-public-subnet-two"
    Type = "public"
  }
}

resource "aws_subnet" "private_subnet_one" {
  availability_zone = element(data.aws_availability_zones.available.names, 0)
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.mappings["SubnetConfig"]["PrivateOne"]["CIDR"]

  tags = {
    Name = "tf-${var.environment_name}-private-subnet-one"
    Type = "private"
  }
}

resource "aws_subnet" "private_subnet_two" {
  availability_zone = element(data.aws_availability_zones.available.names, 1)
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.mappings["SubnetConfig"]["PrivateTwo"]["CIDR"]

  tags = {
    Name = "tf-${var.environment_name}-private-subnet-two"
    Type = "private"
  }
}

# Setup networking resources for the public subnets. Containers in the public subnets have public IP addresses
# and the routing table sends network traffic via the internet gateway.
resource "aws_internet_gateway" "internet_gateway" {
  tags = {
    Name = "tf-${var.environment_name}-internet-gateway"
  }
}

resource "aws_internet_gateway_attachment" "gateway_attachment" {
  internet_gateway_id = aws_internet_gateway.internet_gateway.id
  vpc_id              = aws_vpc.this.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "tf-${var.environment_name}-public-route-table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_subnet_one_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_one.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_two_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_two.id
  route_table_id = aws_route_table.public_route_table.id
}

# Setup networking resources for the private subnets. Containers in these subnets have only private IP addresses,
# and must use a NAT gateway to talk to the internet. We launch two NAT gateways, one for each private subnet.
resource "aws_eip" "nat_gateway_one_attachment" {
#  count  = locals.CreateNatGatewayAttachments ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "tf-${var.environment_name}-nat-gateway-public-subnet-one-eip"
  }
}

resource "aws_eip" "nat_gateway_two_attachment" {
#  count  = locals.CreateNatGatewayAttachments ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "tf-${var.environment_name}-nat-gateway-public-subnet-two-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway_one" {
  allocation_id = aws_eip.nat_gateway_one_attachment.id
  subnet_id     = aws_subnet.public_subnet_one.id

  tags = {
    Name = "cf-${var.environment_name}-nat-gateway-public-subnet-one"
  }
}

resource "aws_nat_gateway" "nat_gateway_two" {
  allocation_id = aws_eip.nat_gateway_two_attachment.id
  subnet_id     = aws_subnet.public_subnet_two.id

  tags = {
    Name = "cf-${var.environment_name}-nat-gateway-public-subnet-two"
  }
}

resource "aws_route_table" "private_route_table_one" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "tf-${var.environment_name}-private-route-table-one"
  }
}

resource "aws_route" "private_route_one" {
  route_table_id         = aws_route_table.private_route_table_one.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_one.id
}

resource "aws_route_table_association" "private_route_table_one_association" {
  route_table_id = aws_route_table.private_route_table_one.id
  subnet_id      = aws_subnet.private_subnet_one.id
}

resource "aws_route_table" "private_route_table_two" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "tf-${var.environment_name}-private-route-table-two"
  }
}

resource "aws_route" "private_route_two" {
  route_table_id         = aws_route_table.private_route_table_two.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_two.id
}

resource "aws_route_table_association" "private_route_table_two_association" {
  route_table_id = aws_route_table.private_route_table_two.id
  subnet_id      = aws_subnet.private_subnet_two.id
}
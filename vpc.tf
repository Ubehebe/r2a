# adapted from https://section411.com/2019/07/hello-world#networking

# the ecs FARGATE launch type requires using a vpc.
resource "aws_vpc" "r2a" {
  cidr_block = "10.0.0.0/16"
}

# by default, vpcs don't have any ingress or egress. so let's set them up.

# public subnet+route table+route table association

resource "aws_subnet" "r2a-public-subnet" {
  vpc_id     = aws_vpc.r2a.id
  cidr_block = "10.0.1.0/25"
}

resource "aws_route_table" "r2a-public-route-table" {
  vpc_id = aws_vpc.r2a.id
}

resource "aws_route_table_association" "r2a-public-association" {
  subnet_id      = aws_subnet.r2a-public-subnet.id
  route_table_id = aws_route_table.r2a-public-route-table.id
}

# private subnet+route table+route table association

resource "aws_subnet" "r2a-private-subnet" {
  vpc_id     = aws_vpc.r2a.id
  cidr_block = "10.0.2.0/25"
}

resource "aws_route_table" "r2a-private-route-table" {
  vpc_id = aws_vpc.r2a.id
}

resource "aws_route_table_association" "private_subnet" {
  subnet_id      = aws_subnet.r2a-private-subnet.id
  route_table_id = aws_route_table.r2a-private-route-table.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_internet_gateway" "r2a-gateway" {
  vpc_id = aws_vpc.r2a.id
}

resource "aws_nat_gateway" "r2a-nat-gateway" {
  subnet_id     = aws_subnet.r2a-public-subnet.id
  allocation_id = aws_eip.nat.id
  depends_on = [
    aws_internet_gateway.r2a-gateway
  ]
}

resource "aws_route" "r2a-public-route" {
  route_table_id         = aws_route_table.r2a-public-route-table.id
  destination_cidr_block = "0.0.0.0/0" # TODO what is this?
  gateway_id             = aws_internet_gateway.r2a-gateway.id
}

resource "aws_route" "r2a-private-route" {
  route_table_id         = aws_route_table.r2a-private-route-table.id
  destination_cidr_block = "0.0.0.0/0" # TODO what is this?
  nat_gateway_id         = aws_nat_gateway.r2a-nat-gateway.id
}

resource "aws_security_group" "r2a-http-ingress" {
  name   = "http"
  vpc_id = aws_vpc.r2a.id

  ingress {
    from_port   = 80
    to_port     = 5678
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"] # TODO what is this?
  }
}

resource "aws_security_group" "r2a-allow-all-egress" {
  name   = "r2a-allow-all-egress"
  vpc_id = aws_vpc.r2a.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # TODO what is this?
  }
}
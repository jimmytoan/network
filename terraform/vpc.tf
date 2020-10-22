#
#  VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway for public subnets
#  * Nat Gateway for private subnets
#  * Route Tables
#

resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/19"
  enable_dns_hostnames = true

  tags = {
    "Name"                                      = "main-vpc"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

## main public subnets
resource "aws_subnet" "main-public" {
  count = length(var.public_subnets)

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = var.public_subnets[count.index]
  vpc_id            = aws_vpc.main.id

  tags = {
    "Name"                                      = "main-public-subnet"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

## internet gateway
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-internet-gateway"
  }
}

resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
}

resource "aws_route_table_association" "main" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.main-public[count.index].id
  route_table_id = aws_route_table.main-public.id
}

## main private subnets
## NAT gateway
## routing table, routing table association

resource "aws_subnet" "main-private" {
  count = length(var.private_subnets)

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = var.private_subnets[count.index]
  vpc_id            = aws_vpc.main.id

  tags = {
    "Name"                                      = "main-private-subnet"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  count = 1

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main-public[count.index].id #public subnet 
  depends_on    = [aws_internet_gateway.main-igw]

  tags = {
    Name = "NAT gw"
  }
}

resource "aws_route_table" "main-private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-private"
  }
}

resource "aws_route_table_association" "main-private" {
  count = length(var.private_subnets)

  subnet_id      = "${aws_subnet.main-private[count.index].id}"
  route_table_id = aws_route_table.main-private.id
}

## Enable internal route for NAT gw
resource "aws_route" "nat_gw" {
  route_table_id         = aws_route_table.main-private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw[0].id
}


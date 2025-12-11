# VPC

resource "aws_vpc" "vpc" {
  cidr_block           = var.aws_vpc.cidr_block
  enable_dns_support   = var.aws_vpc.enable_dns_hostnames
  enable_dns_hostnames = var.aws_vpc.enable_dns_hostnames
  tags                 = var.aws_vpc.tags
}

# Subnets

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_cidr_block)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidr_block[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = var.aws_vpc.tags
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr_block)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_cidr_block[count.index]
  availability_zone = var.availability_zone[count.index]
  tags              = var.aws_vpc.tags
}

# Gateways - Module doesn't create any private Nat Gateways

resource "aws_internet_gateway" "igw" {
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = var.aws_vpc.tags
}

resource "aws_eip" "private_eip" {
  count      = var.create_nat_gateway ? length(var.public_cidr_block) : 0
  depends_on = [aws_internet_gateway.igw]

  tags = var.aws_vpc.tags
}

resource "aws_nat_gateway" "ngw" {
  count         = var.create_nat_gateway ? length(var.public_cidr_block) : 0
  depends_on    = [aws_internet_gateway.igw]
  subnet_id     = aws_subnet.public_subnet[count.index].id
  allocation_id = aws_eip.private_eip[count.index].id

  tags = var.aws_vpc.tags
}

# Route tables

resource "aws_route_table" "public_rt" {
  count  = length(var.public_cidr_block)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = var.aws_vpc.tags
}

resource "aws_route_table" "private_rt" {
  depends_on = [aws_nat_gateway.ngw]
  count      = length(var.private_cidr_block)
  vpc_id     = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw[0].id
  }

  tags = var.aws_vpc.tags
}

# Route Table Association 

resource "aws_route_table_association" "public" {
  count          = length(var.private_cidr_block)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}
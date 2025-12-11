# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.aws_vpc.cidr_block
  enable_dns_support   = var.aws_vpc.enable_dns_hostnames
  enable_dns_hostnames = var.aws_vpc.enable_dns_hostnames
  tags                 = var.aws_vpc.tags
}

# Subnets
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_cidr_block)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_cidr_block[count.index]
  availability_zone = var.availability_zone[count.index]

  map_public_ip_on_launch = true

  tags = "fix"
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr_block)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_cidr_block[count.index]
  availability_zone = var.availability_zone[count.index]
  tags              = "fix"
}

# Gateways - it's not a private nat gateway but public

resource "aws_internet_gateway" "igw" {
  count  = length(var.public_cidr_block) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = "fix"
}

resource "aws_eip" "private_eip" {
  count      = var.create_nat_gateway == true && length(var.public_cidr_block) && length(var.private_cidr_block) > 0 ? length(var.public_cidr_block) : 0
  depends_on = [aws_internet_gateway.igw]

  tags = "fix"
}

resource "aws_nat_gateway" "ngw" {
  count         = var.create_nat_gateway == true && length(var.public_cidr_block) && length(var.private_cidr_block) > 0 ? length(var.public_cidr_block) : 0
  depends_on    = [aws_internet_gateway.igw]
  subnet_id     = var.public_cidr_block[count.index].id
  allocation_id = aws_eip.private_eip[count.index].id

  tags = "fix"
}
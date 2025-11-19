resource "aws_vpc" "vpc" {
  cidr_block           = var.aws_vpc.cidr_block
  enable_dns_support   = var.aws_vpc.enable_dns_hostnames
  enable_dns_hostnames = var.aws_vpc.enable_dns_hostnames
  tags = var.aws_vpc.tags
}

# # Gateways

# resource "aws_internet_gateway" "igw" {
#   count  = length(var.public_cidr_block) > 0 ? 1 : 0
#   vpc_id = aws_vpc.vpc.id

#   tags = merge(local.tags,
#     { Name = "${var.aws_vpc.name}-ig" }
#   )
# }

# resource "aws_eip" "private_eip" {
#   count      = length(var.public_cidr_block) && length(var.private_cidr_block) > 0 ? length(var.public_cidr_block) : 0
#   depends_on = [aws_internet_gateway.igw]

#   tags = merge(local.tags,
#     { Name = "${var.aws_vpc.name}-eip-${count.index + 1}" }
#   )
# }

# resource "aws_nat_gateway" "ngw" {
#   count         = length(var.public_cidr_block) && length(var.private_cidr_block) > 0 ? length(var.public_cidr_block) : 0
#   depends_on    = [aws_internet_gateway.igw]
#   subnet_id     = var.public_cidr_block[count.index].id
#   allocation_id = aws_eip.private_eip[count.index].id

#   tags = merge(local.tags,
#     { Name = "${var.aws_vpc.name}-nat-${count.index + 1}" }
#   )
# }

# # Subnets

# resource "aws_subnet" "public_subnet" {
#   # name              = var.aws_public_subnet_name
#   count             = length(var.public_cidr_block)
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.public_cidr_block[count.index]
#   availability_zone = var.availability_zone[count.index]

#   map_public_ip_on_launch = true

#   tags = merge(local.tags,
#     { Name = "${aws_subnet.public_subnet.name}-${count.index + 1}" }
#   )
# }

# resource "aws_subnet" "private_subnet" {
#   # name              = var.aws_private_subnet_name
#   count             = length(var.private_cidr_block)
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.private_cidr_block[count.index]
#   availability_zone = var.availability_zone[count.index]

#   tags = merge(local.tags,
#     { Name = "${aws_subnet.private_subnet.name}-${count.index + 1}" }
#   )
# }

# resource "aws_subnet" "database_subnet" {
#   # name              = var.aws_db_subnet_name
#   count             = length(var.database_cidr_block)
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.database_cidr_block[count.index]
#   availability_zone = var.availability_zone[count.index]

#   tags = merge(local.tags,
#     { Name = "${aws_subnet.database_subnet.name}-${count.index + 1}" }
#   )
# }

# # Route tables

# resource "aws_route_table" "public" {
#   # name = var.public_rt_name
#   count  = length(var.public_cidr_block)
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = merge(local.tags,
#     { Name = "${aws_route_table.public.name}-rt-${count.index + 1}" }
#   )
# }

# resource "aws_route_table" "private" {
#   # name = var.private_rt_name
#   count  = length(var.private_cidr_block)
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.ngw[count.index].id
#   }

#   tags = merge(local.tags,
#     { Name = "${aws_route_table.private.name}-rt-${count.index + 1}" }
#   )
# }

# # Route Table Association 

# resource "aws_route_table_association" "public" {
#   count          = length(var.private_cidr_block)
#   subnet_id      = aws_subnet.public_subnet[count.index].id
#   route_table_id = aws_route_table.public[count.index].id
# }

# resource "aws_route_table_association" "private" {
#   count          = length(var.private_cidr_block)
#   subnet_id      = aws_subnet.private_subnet[count.index].id
#   route_table_id = aws_route_table.private_subtnet_rt[count.index].id
# }
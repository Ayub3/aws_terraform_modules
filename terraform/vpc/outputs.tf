output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.ngw.allocation_id
}
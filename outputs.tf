output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.*.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc.*.cidr_block
}

# output "nat_gateway_ids" {
#   description = "The IDs of the nat gateways"
#   value = "${aws_nat_gateway.nat.*.id
# }

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_subnet.*.id
}

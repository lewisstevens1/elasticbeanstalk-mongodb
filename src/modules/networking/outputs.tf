output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnets" {
  value = { for subnet in aws_subnet.private_subnets : subnet.id => subnet.cidr_block }
}

output "public_subnets" {
  value = { for subnet in aws_subnet.public_subnets : subnet.id => subnet.cidr_block }
}

output "r53_zone_id" {
  value = aws_route53_zone.local.zone_id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

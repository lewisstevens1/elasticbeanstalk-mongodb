resource "aws_route" "application_to_database" {
  route_table_id         = var.public_route_table_id
  destination_cidr_block = values(var.private_subnets)[0]
  network_interface_id   = aws_network_interface.db.id
}

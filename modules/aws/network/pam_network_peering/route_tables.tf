# Retrieve the private route table
data "aws_route_tables" "private_route_table" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Name"
    values = ["PAMonCloud Private Route Table"]
  }
}

# Adds a route to the route table to the specified CIDR block via the VPC peering connection, based on the action (request or accept).
resource "aws_route" "vpc_peering_route" {
  route_table_id            = data.aws_route_tables.private_route_table.ids[0]
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = var.action == "request" ? aws_vpc_peering_connection.pcx_main[0].id : var.accept_pcx_id
}
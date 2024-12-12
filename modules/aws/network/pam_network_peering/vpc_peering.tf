# This resource creates a VPC peering connection from the requester's VPC to the peer's VPC.
resource "aws_vpc_peering_connection" "pcx_main" {
  count       = var.action == "request" ? 1 : 0
  vpc_id      = var.vpc_id
  peer_vpc_id = var.request_peer_vpc_id
  peer_region = var.request_peer_region
  auto_accept = false

  tags = {
    Name = "PAMonCloud Peering connection"
    Side = "Requester"
  }
}

# This resource accepts an existing VPC peering connection from the peer's VPC.
resource "aws_vpc_peering_connection_accepter" "pcx_peer" {
  count                     = var.action == "accept" ? 1 : 0
  vpc_peering_connection_id = var.accept_pcx_id
  auto_accept               = true

  tags = {
    Name = "PAMonCloud Peering connection"
    Side = "Accepter"
  }
}
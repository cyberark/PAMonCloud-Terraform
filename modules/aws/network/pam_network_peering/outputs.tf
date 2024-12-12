output "peering_connection_id" {
  description = "Peering connection ID"
  value       = aws_vpc_peering_connection.pcx_main[*].id
}
output "vpc_id" {
  description = "VPC ID"
  value       = module.pam_vpc.vpc_id
}

output "public_subnets" {
  description = "Public Subnet IDs"
  value       = module.pam_vpc.public_subnets
}

output "public_route_table_ids" {
  description = "Public route tables IDs"
  value       = module.pam_vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "Private route tables IDs"
  value       = module.pam_vpc.private_route_table_ids
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.pam_vpc.natgw_ids
}

output "security_group_ids" {
  description = "Security Group IDs for all components"
  value       = { for key, sg in aws_security_group.security_group : key => sg.id }
}

output "private_subnets_map" {
  description = "A map of subnet details (id and cidr_block) by name"
  value = {
    for subnet in module.pam_vpc.private_subnet_objects : subnet.tags.Name => {
      id         = subnet.id
      cidr_block = subnet.cidr_block
    }
  }
}

output "sg_rules" {
  value = var.rules
}
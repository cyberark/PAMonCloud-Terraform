# pam_network outputs

output "vpc_id_main" {
  description = "VPC ID in main region"
  value       = module.pam_network_main.vpc_id
}

output "vpc_id_dr" {
  description = "VPC ID in DR region"
  value       = module.pam_network_dr.vpc_id
}

output "public_subnets_main" {
  description = "Public Subnet IDs in main region"
  value       = module.pam_network_main.public_subnets
}

output "public_subnets_dr" {
  description = "Public Subnet IDs in DR region"
  value       = module.pam_network_dr.public_subnets
}

output "public_route_table_ids_main" {
  description = "Public route tables IDs in main region"
  value       = module.pam_network_main.public_route_table_ids
}

output "public_route_table_ids_dr" {
  description = "Public route tables IDs in DR region"
  value       = module.pam_network_dr.public_route_table_ids
}

output "private_route_table_ids_main" {
  description = "Private route tables IDs in main region"
  value       = module.pam_network_main.private_route_table_ids
}

output "private_route_table_ids_dr" {
  description = "Private route tables IDs in DR region"
  value       = module.pam_network_dr.private_route_table_ids
}

output "natgw_ids_main" {
  description = "List of NAT Gateway IDs in main region"
  value       = module.pam_network_main.natgw_ids
}

output "natgw_ids_dr" {
  description = "List of NAT Gateway IDs in DR region"
  value       = module.pam_network_dr.natgw_ids
}

output "security_group_ids_main" {
  description = "Security Group IDs for all components"
  value       = module.pam_network_main.security_group_ids
}

output "security_group_ids_dr" {
  description = "Security Group IDs for all components in DR region"
  value       = module.pam_network_dr.security_group_ids
}

output "private_subnets_map_main" {
  description = "A map of subnet details (id and cidr_block) by name in main region"
  value       = module.pam_network_main.private_subnets_map
}

output "private_subnets_map_dr" {
  description = "A map of subnet details (id and cidr_block) by name in DR region"
  value       = module.pam_network_dr.private_subnets_map
}

# deploy_prep outputs

output "deployment_uid_main" {
  description = "Deployment Unique ID in main region"
  value       = module.deploy_prep_main.deployment_uid
}

output "deployment_uid_dr" {
  description = "Deployment Unique ID in DR region"
  value       = module.deploy_prep_dr.deployment_uid
}

output "log_group_name_main" {
  description = "CloudWatch Log Group name in main region"
  value       = module.deploy_prep_main.log_group_name
}

output "log_group_name_dr" {
  description = "CloudWatch Log Group name in DR region"
  value       = module.deploy_prep_dr.log_group_name
}

# vault_instance outputs

output "vault_instance_ip_address" {
  value = module.vault_instance.instance_ip_address
}

output "vault_instance_private_dns" {
  value = module.vault_instance.instance_private_dns
}

output "vault_instance_id" {
  value = module.vault_instance.instance_id
}

output "vault_instance_hostname" {
  value = module.vault_instance.instance_hostname
}

# vault_dr_instance outputs

output "vault_dr_instance_ip_address" {
  value = module.vault_dr_instance.instance_ip_address
}

output "vault_dr_instance_private_dns" {
  value = module.vault_dr_instance.instance_private_dns
}

output "vault_dr_instance_id" {
  value = module.vault_dr_instance.instance_id
}

output "vault_dr_instance_hostname" {
  value = module.vault_dr_instance.instance_hostname
}

# peering_connection_request outputs

output "peering_connection_request_id" {
  value = module.peering_connection_request.peering_connection_id
}
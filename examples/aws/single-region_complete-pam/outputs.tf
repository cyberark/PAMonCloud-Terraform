# pam_network outputs

output "vpc_id" {
  description = "VPC ID"
  value       = module.pam_network.vpc_id
}

output "public_subnets" {
  description = "Public Subnet IDs"
  value       = module.pam_network.public_subnets
}

output "public_route_table_ids" {
  description = "Public route tables IDs"
  value       = module.pam_network.public_route_table_ids
}

output "private_route_table_ids" {
  description = "Private route tables IDs"
  value       = module.pam_network.private_route_table_ids
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.pam_network.natgw_ids
}

output "security_group_ids" {
  description = "Security Group IDs for all components"
  value       = module.pam_network.security_group_ids
}

output "private_subnets_map" {
  description = "A map of subnet details (id and cidr_block) by name"
  value       = module.pam_network.private_subnets_map
}

# deploy_prep outputs

output "deployment_uid" {
  description = "Deployment Unique ID."
  value       = module.deploy_prep.deployment_uid
}

output "log_group_name" {
  description = "CloudWatch Log Group name."
  value       = module.deploy_prep.log_group_name
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

# pvwa_instance outputs

output "pvwa_instance_ip_address" {
  value = module.pvwa_instance.instance_ip_address
}

output "pvwa_instance_private_dns" {
  value = module.pvwa_instance.instance_private_dns
}

output "pvwa_instance_id" {
  value = module.pvwa_instance.instance_id
}

output "pvwa_instance_hostname" {
  value = module.pvwa_instance.instance_hostname
}

# cpm_instance outputs

output "cpm_instance_ip_address" {
  value = module.cpm_instance.instance_ip_address
}

output "cpm_instance_private_dns" {
  value = module.cpm_instance.instance_private_dns
}

output "cpm_instance_id" {
  value = module.cpm_instance.instance_id
}

output "cpm_instance_hostname" {
  value = module.cpm_instance.instance_hostname
}

# psm_instance outputs

output "psm_instance_ip_address" {
  value = module.psm_instance.instance_ip_address
}

output "psm_instance_private_dns" {
  value = module.psm_instance.instance_private_dns
}

output "psm_instance_id" {
  value = module.psm_instance.instance_id
}

output "psm_instance_hostname" {
  value = module.psm_instance.instance_hostname
}

# psmp_instance outputs

output "psmp_instance_ip_address" {
  value = module.psmp_instance.instance_ip_address
}

output "psmp_instance_private_dns" {
  value = module.psmp_instance.instance_private_dns
}

output "psmp_instance_id" {
  value = module.psmp_instance.instance_id
}

output "psmp_instance_hostname" {
  value = module.psmp_instance.instance_hostname
}

# pta_instance outputs

output "pta_instance_ip_address" {
  value = module.pta_instance.instance_ip_address
}

output "pta_instance_private_dns" {
  value = module.pta_instance.instance_private_dns
}

output "pta_instance_id" {
  value = module.pta_instance.instance_id
}

output "pta_instance_hostname" {
  value = module.pta_instance.instance_hostname
}
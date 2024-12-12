# deploy_prep outputs

output "deployment_uid" {
  description = "Deployment Unique ID."
  value       = module.deploy_prep.deployment_uid
}

output "log_group_name" {
  description = "CloudWatch Log Group name."
  value       = module.deploy_prep.log_group_name
}

# component_instance outputs

output "component_instance_ip_address" {
  value = module.component_instance.instance_ip_address
}

output "component_instance_private_dns" {
  value = module.component_instance.instance_private_dns
}

output "component_instance_id" {
  value = module.component_instance.instance_id
}

output "component_instance_hostname" {
  value = module.component_instance.instance_hostname
}
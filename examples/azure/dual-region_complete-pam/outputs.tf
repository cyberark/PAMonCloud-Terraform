# pam_network outputs

output "rg_name" {
  value = module.pam-network.rg_name
}

output "rg_location" {
  value = module.pam-network.rg_location
}

output "vnet_location" {
  value = module.pam-network.vnet_location
}

output "vault_subnet_id" {
  value = module.pam-network.vault_subnet_id
}

output "pvwa_subnet_id" {
  value = module.pam-network.pvwa_subnet_id
}

output "cpm_subnet_id" {
  value = module.pam-network.cpm_subnet_id
}

output "psm_subnet_id" {
  value = module.pam-network.psm_subnet_id
}

output "psmp_subnet_id" {
  value = module.pam-network.psmp_subnet_id
}

output "pta_subnet_id" {
  value = module.pam-network.pta_subnet_id
}

# vault_vm outputs

output "vault_vm_private_ip" {
  value = module.vault_vm.private_ip
}

output "vault_vm_name" {
  value = module.vault_vm.vm_name
}

output "vault_vm_availability_zone" {
  value = module.vault_vm.availability_zone
}

# vault_dr_vm outputs

output "vault_dr_vm_private_ip" {
  value = module.vault_dr_vm.private_ip
}

output "vault_dr_vm_name" {
  value = module.vault_dr_vm.vm_name
}

output "vault_dr_vm_availability_zone" {
  value = module.vault_dr_vm.availability_zone
}

# pvwa_vm outputs

output "pvwa_private_ip" {
  value = module.pvwa_vm.private_ip
}

output "pvwa_vm_name" {
  value = module.pvwa_vm.vm_name
}

# cpm_vm outputs

output "cpm_private_ip" {
  value = module.cpm_vm.private_ip
}

output "cpm_vm_name" {
  value = module.cpm_vm.vm_name
}

# psm_vm outputs

output "psm_private_ip" {
  value = module.psm_vm.private_ip
}

output "psm_vm_name" {
  value = module.psm_vm.vm_name
}

# psmp_vm outputs

output "psmp_private_ip" {
  value = module.psmp_vm.private_ip
}

output "psmp_vm_name" {
  value = module.psmp_vm.vm_name
}

# pta_vm outputs

output "pta_private_ip" {
  value = module.pta_vm.private_ip
}

output "pta_vm_name" {
  value = module.pta_vm.vm_name
}
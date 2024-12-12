output "private_ip" {
  value = resource.azurerm_network_interface.vault_dr_network_interface.private_ip_address
}

output "vm_name" {
  value = resource.azurerm_virtual_machine.vault_dr_vm.name
}

output "availability_zone" {
  value = length(var.availability_zone) == 0 ? [] : resource.azurerm_virtual_machine.vault_dr_vm.zones
}
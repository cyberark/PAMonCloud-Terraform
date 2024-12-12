output "private_ip" {
  value = resource.azurerm_network_interface.primary_vault_network_interface.private_ip_address
}

output "vm_name" {
  value = resource.azurerm_virtual_machine.primary_vault_vm.name
}

output "availability_zone" {
  value = length(var.availability_zone) == 0 ? [] : resource.azurerm_virtual_machine.primary_vault_vm.zones
}
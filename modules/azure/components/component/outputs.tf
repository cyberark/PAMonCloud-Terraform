output "private_ip" {
  value = resource.azurerm_network_interface.component_network_interface.private_ip_address
}

output "vm_name" {
  value = resource.azurerm_virtual_machine.component_vm.name
}

output "vm_hostname" {
  value = var.vm_hostname
}
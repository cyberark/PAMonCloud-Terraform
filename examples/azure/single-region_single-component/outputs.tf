# component_vm outputs

output "component_private_ip" {
  value = module.component_vm.private_ip
}

output "component_vm_name" {
  value = module.component_vm.vm_name
}
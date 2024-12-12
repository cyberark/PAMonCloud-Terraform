resource "random_uuid" "random_suffix" {
}

data "azurerm_virtual_machine" "vault_vm_data" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name

  depends_on = [resource.azurerm_virtual_machine.primary_vault_vm]
}
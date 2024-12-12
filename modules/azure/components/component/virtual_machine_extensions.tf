resource "azurerm_virtual_machine_extension" "registration_script" {
  name                       = "${var.component}_Registration_To_Vault"
  virtual_machine_id         = azurerm_virtual_machine.component_vm.id
  publisher                  = local.component_data[var.component].extension_publisher
  type                       = local.component_data[var.component].extension_type
  type_handler_version       = local.component_data[var.component].extension_type_handler_version
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
  {
    "commandToExecute": "${local.component_data[var.component].command_to_execute}"
  }
  SETTINGS

  depends_on = [resource.azurerm_virtual_machine.component_vm]
}
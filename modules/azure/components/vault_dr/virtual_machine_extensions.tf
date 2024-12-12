resource "azurerm_virtual_machine_extension" "registration_script" {
  name                       = "VaultDR_Registration_Script"
  virtual_machine_id         = azurerm_virtual_machine.vault_dr_vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
 {
  "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File \"C://CyberArk//HardeningActivation.ps1\" -PrimaryOrDR DR -PrimaryVaultIP ${var.primary_vault_private_ip} -DRPassword ${var.vault_dr_password} -VKMName ${var.key_vault_name} -Secret ${var.vault_dr_secret}"
 }
SETTINGS

  depends_on = [resource.azurerm_virtual_machine.vault_dr_vm, resource.azurerm_key_vault.vault_dr_key_vault]
}
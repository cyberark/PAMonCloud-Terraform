resource "azurerm_virtual_machine_extension" "registration_script" {
  name                       = "PrimaryVault_Registration_Script"
  virtual_machine_id         = azurerm_virtual_machine.primary_vault_vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
 {
  "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File \"C://CyberArk//HardeningActivation.ps1\" -AdminPass ${var.vault_admin_password} -MasterPass ${var.vault_master_password} -PrimaryOrDR Primary -PrimaryVaultIP 1.1.1.1 -DRPassword ${var.vault_dr_password} -LicenseFileName ${var.license_file} -RecPubFileName ${var.recovery_public_key_file} -StorageName ${var.storage_account_name} -ContainerName ${var.container_name} -StorageAccountKey ${var.storage_account_access_key} -VKMName ${var.key_vault_name} -Secret ${var.vault_dr_secret}"
 }
SETTINGS

  depends_on = [resource.azurerm_virtual_machine.primary_vault_vm, resource.azurerm_key_vault.primary_vault_key_vault]
}
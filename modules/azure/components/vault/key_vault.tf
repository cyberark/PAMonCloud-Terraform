resource "azurerm_key_vault" "primary_vault_key_vault" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_virtual_machine.vault_vm_data.identity[0].tenant_id
  sku_name            = "premium"

  access_policy {
    tenant_id = data.azurerm_virtual_machine.vault_vm_data.identity[0].tenant_id
    object_id = data.azurerm_virtual_machine.vault_vm_data.identity[0].principal_id

    key_permissions = [
      "Create",
      "WrapKey",
      "UnwrapKey"
    ]
  }

  network_acls {
    bypass                     = "None"
    default_action             = "Deny"
    virtual_network_subnet_ids = compact(tolist([var.subnet_id.primary, var.subnet_id.peered]))
  }
}
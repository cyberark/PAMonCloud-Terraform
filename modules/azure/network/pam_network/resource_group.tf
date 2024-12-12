resource "azurerm_resource_group" "pamoncaloud_rg" {
  name     = var.resource_group_name
  location = var.vnet_location_primary

  tags = {
    Name = "PAMonCloud-TF-RG"
  }
}
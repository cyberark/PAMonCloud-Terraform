resource "azurerm_virtual_network_peering" "peering" {
  count = (length(local.vnet_name_to_id_tuple)) < 2 ? 0 : (length(local.vnet_name_to_id_tuple))

  name                         = "${element(local.vnet_name_to_id_tuple[*].vnet_name, count.index)}-to-${element(local.vnet_name_to_id_tuple[*].vnet_name, 1 - count.index)}"
  resource_group_name          = azurerm_resource_group.pamoncaloud_rg.name
  virtual_network_name         = element(local.vnet_name_to_id_tuple[*].vnet_name, count.index)
  remote_virtual_network_id    = element(local.vnet_name_to_id_tuple[*].vnet_id, 1 - count.index)
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}
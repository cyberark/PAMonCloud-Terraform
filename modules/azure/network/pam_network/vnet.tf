module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "4.1.0"

  for_each            = local.vnet_location_to_cidr_map
  use_for_each        = true
  vnet_location       = each.key
  vnet_name           = "PAM-VNet-${each.key}"
  address_space       = tolist([each.value])
  resource_group_name = azurerm_resource_group.pamoncaloud_rg.name
  nsg_ids             = { for subnet, id in local.subnet_to_nsg_id_map : subnet => id if strcontains(subnet, each.key) }
  subnet_prefixes = [
    cidrsubnet(each.value, 8, 1),
    cidrsubnet(each.value, 8, 2),
    cidrsubnet(each.value, 8, 3),
    cidrsubnet(each.value, 8, 4),
    cidrsubnet(each.value, 8, 5),
    cidrsubnet(each.value, 8, 6)]
  subnet_names = [
    "Vault-Subnet-${each.key}",
    "PVWA-Subnet-${each.key}",
    "CPM-Subnet-${each.key}",
    "PSM-Subnet-${each.key}",
    "PSMP-Subnet-${each.key}",
    "PTA-Subnet-${each.key}"
  ]
  subnet_service_endpoints = {
    "Vault-Subnet-${each.key}" = ["Microsoft.KeyVault"]
  }

  tags = {
    Name = "PAMonCloud-VNet-${each.key}"
  }
}
output "rg_name" {
  value = resource.azurerm_resource_group.pamoncaloud_rg.name
}

output "rg_location" {
  value = resource.azurerm_resource_group.pamoncaloud_rg.location
}

output "vnet_location" {
  value = {
    primary = local.vnets_data.vnet_location[0]
    peered  = length(local.vnets_data.vnet_location) > 1 ? local.vnets_data.vnet_location[1] : null
  }
}

output "vault_subnet_id" {
  value = {
    primary = data.azurerm_subnet.subnet_map["Vault-Subnet-${local.vnets_data.vnet_location[0]}"].id
    peered  = length(local.vnets_data.vnet_location) > 1 ? data.azurerm_subnet.subnet_map["Vault-Subnet-${local.vnets_data.vnet_location[1]}"].id : null
  }
}

output "pvwa_subnet_id" {
  value = {
    primary = data.azurerm_subnet.subnet_map["PVWA-Subnet-${local.vnets_data.vnet_location[0]}"].id
    peered  = length(local.vnets_data.vnet_location) > 1 ? data.azurerm_subnet.subnet_map["PVWA-Subnet-${local.vnets_data.vnet_location[1]}"].id : null
  }
}

output "cpm_subnet_id" {
  value = {
    primary = data.azurerm_subnet.subnet_map["CPM-Subnet-${local.vnets_data.vnet_location[0]}"].id
    peered  = length(local.vnets_data.vnet_location) > 1 ? data.azurerm_subnet.subnet_map["CPM-Subnet-${local.vnets_data.vnet_location[1]}"].id : null
  }
}

output "psm_subnet_id" {
  value = {
    primary = data.azurerm_subnet.subnet_map["PSM-Subnet-${local.vnets_data.vnet_location[0]}"].id
    peered  = length(local.vnets_data.vnet_location) > 1 ? data.azurerm_subnet.subnet_map["PSM-Subnet-${local.vnets_data.vnet_location[1]}"].id : null
  }
}

output "psmp_subnet_id" {
  value = {
    primary = data.azurerm_subnet.subnet_map["PSMP-Subnet-${local.vnets_data.vnet_location[0]}"].id
    peered  = length(local.vnets_data.vnet_location) > 1 ? data.azurerm_subnet.subnet_map["PSMP-Subnet-${local.vnets_data.vnet_location[1]}"].id : null
  }
}

output "pta_subnet_id" {
  value = {
    primary = data.azurerm_subnet.subnet_map["PTA-Subnet-${local.vnets_data.vnet_location[0]}"].id
    peered  = length(local.vnets_data.vnet_location) > 1 ? data.azurerm_subnet.subnet_map["PTA-Subnet-${local.vnets_data.vnet_location[1]}"].id : null
  }
}
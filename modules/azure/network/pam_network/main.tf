locals {
  components = [
    "Vault",
    "CPM",
    "PVWA",
    "PSM",
    "PSMP",
    "PTA"
  ]

  location_to_nsg_rules_product = setproduct(local.nsg_rules_tuple, local.vnets_data.vnet_location)
  vnet_name_to_id_tuple         = [for vnet in module.vnet : { vnet_name = vnet.vnet_name, vnet_id = vnet.vnet_id }]
  components_to_location_list   = setproduct(local.components, local.vnets_data.vnet_location)
  vnet_location_to_cidr_map     = zipmap(local.vnets_data.vnet_location[*], local.vnets_data.vnet_cidr[*])

  vnets_data = {
    vnet_location = compact(tolist([var.vnet_location_primary, var.vnet_location_peered]))
    vnet_cidr     = compact(tolist([var.vnet_cidr_primary, var.vnet_cidr_peered]))
  }

  subnet_to_nsg_id_map = tomap({
    for nsg, id in module.network-security-group : "${split("-", nsg)[0]}-Subnet-${split("-", nsg)[1]}" => id.network_security_group_id
  })

  subnet_to_vnet_map = merge([
    for vnet in module.vnet : {
      for subnet_name, subnet_id in vnet.vnet_subnets_name_id :
      subnet_name => vnet.vnet_name
    }
  ]...)

  subnet_to_address_prefixes_map = { for subnet in tomap(data.azurerm_subnet.subnet_map) :
    subnet.name => tostring(subnet.address_prefixes[0])
  }

  components_to_location_map = { for item in local.components_to_location_list :
    format("%s-%s", item[0], item[1]) => item[1]
  }

  concatenate_location_to_nsg_rules = [
    for item in local.location_to_nsg_rules_product : [
      {
        access                     = item[0].access
        direction                  = item[0].direction
        name                       = item[0].name
        priority                   = item[0].priority
        protocol                   = item[0].protocol
        nsg_name                   = "${item[0].nsg_name}-${item[1]}"
        destination_address_prefix = strcontains(item[0].destination_address_prefix, "Subnet") ? "${item[0].destination_address_prefix}-${item[1]}" : item[0].destination_address_prefix
        destination_port_range     = (strcontains(item[0].destination_port_range, "Subnet") ? "${item[0].destination_port_range}-${item[1]}" : item[0].destination_port_range)
        source_address_prefix      = (strcontains(item[0].source_address_prefix, "Subnet") ? "${item[0].source_address_prefix}-${item[1]}" : item[0].source_address_prefix)
        source_port_range          = (strcontains(item[0].source_port_range, "Subnet") ? "${item[0].source_port_range}-${item[1]}" : item[0].source_port_range)
      },
      item[1],
    ]
  ]

  location_to_nsg_rules_tuple = [
    for item in local.concatenate_location_to_nsg_rules : [
      {
        access                     = item[0].access
        direction                  = item[0].direction
        name                       = item[0].name
        nsg_name                   = item[0].nsg_name
        priority                   = item[0].priority
        protocol                   = item[0].protocol
        destination_address_prefix = contains(keys(local.subnet_to_address_prefixes_map), item[0].destination_address_prefix) ? local.subnet_to_address_prefixes_map[item[0].destination_address_prefix] : item[0].destination_address_prefix
        destination_port_range     = contains(keys(local.subnet_to_address_prefixes_map), item[0].destination_port_range) ? local.subnet_to_address_prefixes_map[item[0].destination_port_range] : item[0].destination_port_range
        source_address_prefix      = contains(keys(local.subnet_to_address_prefixes_map), item[0].source_address_prefix) ? local.subnet_to_address_prefixes_map[item[0].source_address_prefix] : item[0].source_address_prefix
        source_port_range          = contains(keys(local.subnet_to_address_prefixes_map), item[0].source_port_range) ? local.subnet_to_address_prefixes_map[item[0].source_port_range] : item[0].source_port_range
      }
    ]
  ]
}

data "azurerm_subnet" "subnet_map" {
  for_each = local.subnet_to_vnet_map

  name                 = each.key
  virtual_network_name = each.value
  resource_group_name  = azurerm_resource_group.pamoncaloud_rg.name
}
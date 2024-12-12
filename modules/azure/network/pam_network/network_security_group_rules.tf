resource "azurerm_network_security_rule" "nsg_rules_per_location" {
  count = length(local.location_to_nsg_rules_tuple)

  resource_group_name         = var.resource_group_name
  network_security_group_name = (element(local.location_to_nsg_rules_tuple[*], count.index)[0].nsg_name)
  name                        = (element(local.location_to_nsg_rules_tuple[*], count.index))[0].name
  protocol                    = (element(local.location_to_nsg_rules_tuple[*], count.index))[0].protocol
  priority                    = (element(local.location_to_nsg_rules_tuple[*], count.index))[0].priority
  direction                   = (element(local.location_to_nsg_rules_tuple[*], count.index))[0].direction
  access                      = (element(local.location_to_nsg_rules_tuple[*], count.index))[0].access
  source_port_range           = (element(local.location_to_nsg_rules_tuple[*], count.index))[0].source_port_range
  destination_port_range      = (element(local.location_to_nsg_rules_tuple[*], count.index))[0].destination_port_range
  source_address_prefix       = (element(local.location_to_nsg_rules_tuple[*], count.index))[0].source_address_prefix
  destination_address_prefix  = (element(local.location_to_nsg_rules_tuple[*], count.index))[0].destination_address_prefix
}

locals {
  nsg_rules_tuple = [
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "AllowICMPOut"
      "protocol"                   = "Icmp"
      "source_port_range"          = "*"
      "destination_port_range"     = "*"
      "source_address_prefix"      = "*"
      "destination_address_prefix" = "*"
      "access"                     = "Allow"
      "priority"                   = 100
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "AllowHTTPSOut"
      "protocol"                   = "Tcp"
      "source_port_range"          = "*"
      "destination_port_range"     = "443"
      "source_address_prefix"      = "*"
      "destination_address_prefix" = "*"
      "access"                     = "Allow"
      "priority"                   = 110
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "AllowRDPOut"
      "protocol"                   = "*"
      "source_port_range"          = "*"
      "destination_port_range"     = "3389"
      "source_address_prefix"      = "*"
      "destination_address_prefix" = "*"
      "access"                     = "Allow"
      "priority"                   = 120
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "AllowDNSOut"
      "protocol"                   = "*"
      "source_port_range"          = "*"
      "destination_port_range"     = "53"
      "source_address_prefix"      = "*"
      "destination_address_prefix" = "168.63.129.16/32"
      "access"                     = "Allow"
      "priority"                   = 130
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "Allow32526Out"
      "protocol"                   = "Tcp"
      "source_port_range"          = "*"
      "destination_port_range"     = "32526"
      "source_address_prefix"      = "*"
      "destination_address_prefix" = "168.63.129.16/32"
      "access"                     = "Allow"
      "priority"                   = 140
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "AllowHTTPOut1"
      "protocol"                   = "Tcp"
      "source_port_range"          = "*"
      "destination_port_range"     = "80"
      "source_address_prefix"      = "*"
      "destination_address_prefix" = "168.63.129.16/32"
      "access"                     = "Allow"
      "priority"                   = 150
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "AllowHTTPOut2"
      "protocol"                   = "Tcp"
      "source_port_range"          = "*"
      "destination_port_range"     = "80"
      "source_address_prefix"      = "*"
      "destination_address_prefix" = "169.254.169.254/32"
      "access"                     = "Allow"
      "priority"                   = 160
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "AllowKMSOut"
      "protocol"                   = "Tcp"
      "source_port_range"          = "*"
      "destination_port_range"     = "1688"
      "source_address_prefix"      = "*"
      "destination_address_prefix" = "23.102.135.246/32"
      "access"                     = "Allow"
      "priority"                   = 170
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "Allow1858Out"
      "protocol"                   = "Tcp"
      "source_port_range"          = "*"
      "destination_port_range"     = "1858"
      "source_address_prefix"      = "Vault-Subnet"
      "destination_address_prefix" = "Vault-Subnet"
      "access"                     = "Allow"
      "priority"                   = 180
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "AllowICMPIn"
      "protocol"                   = "Icmp"
      "source_port_range"          = "*"
      "destination_port_range"     = "*"
      "source_address_prefix"      = "*"
      "destination_address_prefix" = "*"
      "access"                     = "Allow"
      "priority"                   = 100
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "Allow1858ComponentsIn1"
      "protocol"                   = "Tcp"
      "source_port_range"          = "1858"
      "destination_port_range"     = "1858"
      "source_address_prefix"      = "PVWA-Subnet"
      "destination_address_prefix" = "Vault-Subnet"
      "access"                     = "Allow"
      "priority"                   = 110
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "Allow1858ComponentsIn2"
      "protocol"                   = "Tcp"
      "source_port_range"          = "1858"
      "destination_port_range"     = "1858"
      "source_address_prefix"      = "CPM-Subnet"
      "destination_address_prefix" = "Vault-Subnet"
      "access"                     = "Allow"
      "priority"                   = 120
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "Allow1858ComponentsIn3"
      "protocol"                   = "Tcp"
      "source_port_range"          = "1858"
      "destination_port_range"     = "1858"
      "source_address_prefix"      = "PSM-Subnet"
      "destination_address_prefix" = "Vault-Subnet"
      "access"                     = "Allow"
      "priority"                   = 130
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "Allow1858ComponentsIn4"
      "protocol"                   = "Tcp"
      "source_port_range"          = "1858"
      "destination_port_range"     = "1858"
      "source_address_prefix"      = "PSMP-Subnet"
      "destination_address_prefix" = "Vault-Subnet"
      "access"                     = "Allow"
      "priority"                   = 140
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "Allow1858ComponentsIn5"
      "protocol"                   = "Tcp"
      "source_port_range"          = "1858"
      "destination_port_range"     = "1858"
      "source_address_prefix"      = "PTA-Subnet"
      "destination_address_prefix" = "Vault-Subnet"
      "access"                     = "Allow"
      "priority"                   = 150
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "Vault-NSG"
      "name"                       = "AllowRabbitPVWA"
      "protocol"                   = "Tcp"
      "source_port_range"          = "5671"
      "destination_port_range"     = "5671"
      "source_address_prefix"      = "PVWA-Subnet"
      "destination_address_prefix" = "Vault-Subnet"
      "access"                     = "Allow"
      "priority"                   = 160
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PVWA-NSG"
      "name"                       = "AllowHttpsComponentsSubnetIn1"
      "protocol"                   = "Tcp"
      "source_port_range"          = "443"
      "destination_port_range"     = "443"
      "source_address_prefix"      = "PVWA-Subnet"
      "destination_address_prefix" = "PVWA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 100
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PVWA-NSG"
      "name"                       = "AllowHttpsComponentsSubnetIn2"
      "protocol"                   = "Tcp"
      "source_port_range"          = "443"
      "destination_port_range"     = "443"
      "source_address_prefix"      = "CPM-Subnet"
      "destination_address_prefix" = "PVWA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 110
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PVWA-NSG"
      "name"                       = "AllowHttpsComponentsSubnetIn3"
      "protocol"                   = "Tcp"
      "source_port_range"          = "443"
      "destination_port_range"     = "443"
      "source_address_prefix"      = "PSM-Subnet"
      "destination_address_prefix" = "PVWA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 120
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PVWA-NSG"
      "name"                       = "AllowHttpsComponentsSubnetIn4"
      "protocol"                   = "Tcp"
      "source_port_range"          = "443"
      "destination_port_range"     = "443"
      "source_address_prefix"      = "PSMP-Subnet"
      "destination_address_prefix" = "PVWA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 130
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PVWA-NSG"
      "name"                       = "AllowHttpsComponentsSubnetIn5"
      "protocol"                   = "Tcp"
      "source_port_range"          = "443"
      "destination_port_range"     = "443"
      "source_address_prefix"      = "PTA-Subnet"
      "destination_address_prefix" = "PVWA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 140
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PVWA-NSG"
      "name"                       = "AllowHttpsUserAccessIn"
      "protocol"                   = "Tcp"
      "source_port_range"          = "443"
      "destination_port_range"     = "443"
      "source_address_prefix"      = var.users_access_cidr
      "destination_address_prefix" = "PVWA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 150
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PVWA-NSG"
      "name"                       = "AllowRDPAdministrativeAccessIn"
      "protocol"                   = "Tcp"
      "source_port_range"          = "3389"
      "destination_port_range"     = "3389"
      "source_address_prefix"      = var.administrative_access_cidr
      "destination_address_prefix" = "PVWA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 160
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PVWA-NSG"
      "name"                       = "Allow1858VaultOut"
      "protocol"                   = "Tcp"
      "source_port_range"          = "1858"
      "destination_port_range"     = "1858"
      "source_address_prefix"      = "PVWA-Subnet"
      "destination_address_prefix" = "Vault-Subnet"
      "access"                     = "Allow"
      "priority"                   = 100
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PVWA-NSG"
      "name"                       = "AllowPTAOut"
      "protocol"                   = "Tcp"
      "source_port_range"          = "8443"
      "destination_port_range"     = "8443"
      "source_address_prefix"      = "PVWA-Subnet"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 110
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PVWA-NSG"
      "name"                       = "AllowRabbitVault"
      "protocol"                   = "Tcp"
      "source_port_range"          = "5671"
      "destination_port_range"     = "5671"
      "source_address_prefix"      = "PVWA-Subnet"
      "destination_address_prefix" = "Vault-Subnet"
      "access"                     = "Allow"
      "priority"                   = 120
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "CPM-NSG"
      "name"                       = "AllowRDPAdministrativeAccessIn"
      "protocol"                   = "Tcp"
      "source_port_range"          = "3389"
      "destination_port_range"     = "3389"
      "source_address_prefix"      = var.administrative_access_cidr
      "destination_address_prefix" = "CPM-Subnet"
      "access"                     = "Allow"
      "priority"                   = 100
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "CPM-NSG"
      "name"                       = "Allow1858VaultSubnetOut"
      "protocol"                   = "Tcp"
      "source_port_range"          = "1858"
      "destination_port_range"     = "1858"
      "source_address_prefix"      = "CPM-Subnet"
      "destination_address_prefix" = "Vault-Subnet"
      "access"                     = "Allow"
      "priority"                   = 100
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "CPM-NSG"
      "name"                       = "AllowHttpsWebSubnetOut"
      "protocol"                   = "Tcp"
      "source_port_range"          = "443"
      "destination_port_range"     = "443"
      "source_address_prefix"      = "CPM-Subnet"
      "destination_address_prefix" = "PVWA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 110
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PSM-NSG"
      "name"                       = "AllowRDPAdministrativeAccessIn"
      "protocol"                   = "Tcp"
      "source_port_range"          = "3389"
      "destination_port_range"     = "3389"
      "source_address_prefix"      = var.administrative_access_cidr
      "destination_address_prefix" = "PSM-Subnet"
      "access"                     = "Allow"
      "priority"                   = 100
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PSM-NSG"
      "name"                       = "AllowRDPUserAccessIn"
      "protocol"                   = "Tcp"
      "source_port_range"          = "3389"
      "destination_port_range"     = "3389"
      "source_address_prefix"      = var.users_access_cidr
      "destination_address_prefix" = "PSM-Subnet"
      "access"                     = "Allow"
      "priority"                   = 110
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PSM-NSG"
      "name"                       = "Allow1858VaultSubnetOut"
      "protocol"                   = "Tcp"
      "source_port_range"          = "1858"
      "destination_port_range"     = "1858"
      "source_address_prefix"      = "PSM-Subnet"
      "destination_address_prefix" = "Vault-Subnet"
      "access"                     = "Allow"
      "priority"                   = 100
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PSM-NSG"
      "name"                       = "AllowHttpsWebSubnetOut"
      "protocol"                   = "Tcp"
      "source_port_range"          = "443"
      "destination_port_range"     = "443"
      "source_address_prefix"      = "PSM-Subnet"
      "destination_address_prefix" = "PVWA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 110
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PSMP-NSG"
      "name"                       = "AllowSshUserAccessIn"
      "protocol"                   = "Tcp"
      "source_port_range"          = "22"
      "destination_port_range"     = "22"
      "source_address_prefix"      = var.users_access_cidr
      "destination_address_prefix" = "PSMP-Subnet"
      "access"                     = "Allow"
      "priority"                   = 100
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PSMP-NSG"
      "name"                       = "AllowSshAdministrativeAccessIn"
      "protocol"                   = "Tcp"
      "source_port_range"          = "22"
      "destination_port_range"     = "22"
      "source_address_prefix"      = var.administrative_access_cidr
      "destination_address_prefix" = "PSMP-Subnet"
      "access"                     = "Allow"
      "priority"                   = 120
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PSMP-NSG"
      "name"                       = "AllowPVWAout"
      "protocol"                   = "Tcp"
      "source_port_range"          = "443"
      "destination_port_range"     = "443"
      "source_address_prefix"      = "PSMP-Subnet"
      "destination_address_prefix" = "PVWA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 100
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PSMP-NSG"
      "name"                       = "AllowSshOut"
      "protocol"                   = "Tcp"
      "source_port_range"          = "22"
      "destination_port_range"     = "22"
      "source_address_prefix"      = "PSMP-Subnet"
      "destination_address_prefix" = "0.0.0.0/0"
      "access"                     = "Allow"
      "priority"                   = 110
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PSMP-NSG"
      "name"                       = "Allow1858VaultOut"
      "protocol"                   = "Tcp"
      "source_port_range"          = "1858"
      "destination_port_range"     = "1858"
      "source_address_prefix"      = "PSMP-Subnet"
      "destination_address_prefix" = "Vault-Subnet"
      "access"                     = "Allow"
      "priority"                   = 130
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInTCP1"
      "protocol"                   = "Tcp"
      "source_port_range"          = "80"
      "destination_port_range"     = "80"
      "source_address_prefix"      = "PVWA-Subnet"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 100
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInTCP2"
      "protocol"                   = "Tcp"
      "source_port_range"          = "8080"
      "destination_port_range"     = "8080"
      "source_address_prefix"      = "PVWA-Subnet"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 110
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInTCP3"
      "protocol"                   = "Tcp"
      "source_port_range"          = "8443"
      "destination_port_range"     = "8443"
      "source_address_prefix"      = "PVWA-Subnet"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 120
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInTCP4"
      "protocol"                   = "Tcp"
      "source_port_range"          = "443"
      "destination_port_range"     = "443"
      "source_address_prefix"      = "PVWA-Subnet"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 130
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInTCP5"
      "protocol"                   = "Tcp"
      "source_port_range"          = "80"
      "destination_port_range"     = "80"
      "source_address_prefix"      = var.administrative_access_cidr
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 140
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInTCP6"
      "protocol"                   = "Tcp"
      "source_port_range"          = "8080"
      "destination_port_range"     = "8080"
      "source_address_prefix"      = var.administrative_access_cidr
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 150
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInTCP7"
      "protocol"                   = "Tcp"
      "source_port_range"          = "8443"
      "destination_port_range"     = "8443"
      "source_address_prefix"      = var.administrative_access_cidr
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 160
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInTCP8"
      "protocol"                   = "Tcp"
      "source_port_range"          = "443"
      "destination_port_range"     = "443"
      "source_address_prefix"      = var.administrative_access_cidr
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 170
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInTCP9"
      "protocol"                   = "Tcp"
      "source_port_range"          = "7514"
      "destination_port_range"     = "7514"
      "source_address_prefix"      = "0.0.0.0/0"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 180
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInTCP10"
      "protocol"                   = "Tcp"
      "source_port_range"          = "6514"
      "destination_port_range"     = "6514"
      "source_address_prefix"      = "0.0.0.0/0"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 190
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInTCP11"
      "protocol"                   = "Tcp"
      "source_port_range"          = "11514"
      "destination_port_range"     = "11514"
      "source_address_prefix"      = "0.0.0.0/0"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 200
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInShh1"
      "protocol"                   = "Tcp"
      "source_port_range"          = "22"
      "destination_port_range"     = "22"
      "source_address_prefix"      = "PTA-Subnet"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 210
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInShh2"
      "protocol"                   = "Tcp"
      "source_port_range"          = "22"
      "destination_port_range"     = "22"
      "source_address_prefix"      = var.administrative_access_cidr
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 220
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInUdp1"
      "protocol"                   = "Udp"
      "source_port_range"          = "67"
      "destination_port_range"     = "67"
      "source_address_prefix"      = "0.0.0.0/0"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 230
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInUdp2"
      "protocol"                   = "Udp"
      "source_port_range"          = "68"
      "destination_port_range"     = "68"
      "source_address_prefix"      = "0.0.0.0/0"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 240
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowInUdp3"
      "protocol"                   = "Udp"
      "source_port_range"          = "11514"
      "destination_port_range"     = "11514"
      "source_address_prefix"      = "0.0.0.0/0"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 250
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowIn27017"
      "protocol"                   = "Tcp"
      "source_port_range"          = "27017"
      "destination_port_range"     = "27017"
      "source_address_prefix"      = "PTA-Subnet"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 260
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowIn514"
      "protocol"                   = "Tcp"
      "source_port_range"          = "514"
      "destination_port_range"     = "514"
      "source_address_prefix"      = "Vault-Subnet"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 270
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowIn514Udp"
      "protocol"                   = "Udp"
      "source_port_range"          = "514"
      "destination_port_range"     = "514"
      "source_address_prefix"      = "Vault-Subnet"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 280
      "direction"                  = "Inbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutTcp1"
      "protocol"                   = "Udp"
      "source_port_range"          = "389"
      "destination_port_range"     = "389"
      "source_address_prefix"      = "0.0.0.0/0"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 100
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutTcp2"
      "protocol"                   = "Udp"
      "source_port_range"          = "443"
      "destination_port_range"     = "443"
      "source_address_prefix"      = "0.0.0.0/0"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 110
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutTcp3"
      "protocol"                   = "Udp"
      "source_port_range"          = "514"
      "destination_port_range"     = "514"
      "source_address_prefix"      = "0.0.0.0/0"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 120
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutTcp4"
      "protocol"                   = "Udp"
      "source_port_range"          = "3268"
      "destination_port_range"     = "3268"
      "source_address_prefix"      = "0.0.0.0/0"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 130
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutTcp5"
      "protocol"                   = "Udp"
      "source_port_range"          = "3269"
      "destination_port_range"     = "3269"
      "source_address_prefix"      = "0.0.0.0/0"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 140
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutTcp6"
      "protocol"                   = "Udp"
      "source_port_range"          = "636"
      "destination_port_range"     = "636"
      "source_address_prefix"      = "0.0.0.0/0"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 150
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutTcp7"
      "protocol"                   = "Udp"
      "source_port_range"          = "587"
      "destination_port_range"     = "587"
      "source_address_prefix"      = "0.0.0.0/0"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 160
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutTcp8"
      "protocol"                   = "Udp"
      "source_port_range"          = "25"
      "destination_port_range"     = "25"
      "source_address_prefix"      = "0.0.0.0/0"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 170
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutTcp9"
      "protocol"                   = "Tcp"
      "source_port_range"          = "22"
      "destination_port_range"     = "22"
      "source_address_prefix"      = "PTA-Subnet"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 180
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutTcp10"
      "protocol"                   = "Tcp"
      "source_port_range"          = "27017"
      "destination_port_range"     = "27017"
      "source_address_prefix"      = "PTA-Subnet"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 190
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutTcp11"
      "protocol"                   = "Tcp"
      "source_port_range"          = "22"
      "destination_port_range"     = "22"
      "source_address_prefix"      = "PTA-Subnet"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 200
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutTcp12"
      "protocol"                   = "Tcp"
      "source_port_range"          = "27017"
      "destination_port_range"     = "27017"
      "source_address_prefix"      = "PTA-Subnet"
      "destination_address_prefix" = "PTA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 210
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutTcp13"
      "protocol"                   = "Tcp"
      "source_port_range"          = "80"
      "destination_port_range"     = "80"
      "source_address_prefix"      = "PTA-Subnet"
      "destination_address_prefix" = "PVWA-Subnet"
      "access"                     = "Allow"
      "priority"                   = 220
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutTcp14"
      "protocol"                   = "Tcp"
      "source_port_range"          = "1858"
      "destination_port_range"     = "1858"
      "source_address_prefix"      = "PTA-Subnet"
      "destination_address_prefix" = "Vault-Subnet"
      "access"                     = "Allow"
      "priority"                   = 230
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutUdp1"
      "protocol"                   = "Udp"
      "source_port_range"          = "514"
      "destination_port_range"     = "514"
      "source_address_prefix"      = "PTA-Subnet"
      "destination_address_prefix" = "0.0.0.0/0"
      "access"                     = "Allow"
      "priority"                   = 240
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutUdp2"
      "protocol"                   = "Udp"
      "source_port_range"          = "123"
      "destination_port_range"     = "123"
      "source_address_prefix"      = "PTA-Subnet"
      "destination_address_prefix" = "0.0.0.0/0"
      "access"                     = "Allow"
      "priority"                   = 250
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutUdp3"
      "protocol"                   = "Udp"
      "source_port_range"          = "53"
      "destination_port_range"     = "53"
      "source_address_prefix"      = "PTA-Subnet"
      "destination_address_prefix" = "0.0.0.0/0"
      "access"                     = "Allow"
      "priority"                   = 260
      "direction"                  = "Outbound"
    },
    {
      "nsg_name"                   = "PTA-NSG"
      "name"                       = "AllowOutUdp4"
      "protocol"                   = "Udp"
      "source_port_range"          = "1858"
      "destination_port_range"     = "1858"
      "source_address_prefix"      = "PTA-Subnet"
      "destination_address_prefix" = "Vault-Subnet"
      "access"                     = "Allow"
      "priority"                   = 270
      "direction"                  = "Outbound"
    }
  ]
}
# PAMonCloud for Azure - Network Terraform Module

This module creates all necessary network resources required for the deployment process on Azure. It includes creating virtual networks (VNets), subnets, route tables, network security groups (NSGs), and private endpoints for Azure services.

## Usage

See [`examples`](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/azure) directory for working examples to reference:

```hcl
module "pam-network" {
    source       = "../../../modules/azure/network/pam_network"

    resource_group_name = "ResourceGroupName"
    vnet_location_primary = "10.0.0.0/16"
    vnet_cidr_primary = "westeurope"
    vnet_location_peered = "eastus" // Optional when deploy in dual region.
    vnet_cidr_peered = "10.0.1.0/16" // Optional when deploy in dual region.
    users_access_cidr = "192.168.0.0/16"
    administrative_access_cidr = "192.168.1.0/24"
}
```

## Examples

- [single-region_complete-pam](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/azure/single-region_complete-pam) with PAM network.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.116.0 |

## Modules

No modules.

## Resources

### Retrieve information about a resource (post deployment)
You can use the `terraform state show` command followed by: `module.<module_name>.<resource_name>`  
Example: `terraform state show 'module.pam-network.azurerm_resource_group.pamoncaloud_rg'`  
For list objects, you can use `terraform state list` to get all objects within the list.

| Resource                                                                                     | Description                                                  |
|----------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `data.azurerm_subnet.subnet_map` (list)                                                      | A list of subnets used in the network configuration.         |
| `azurerm_network_security_rule.nsg_rules_per_location` (list)                                | Network security rules associated with each location.        |
| `azurerm_resource_group.pamoncaloud_rg`                                                      | The resource group used for the PAM network setup.           |
| `module.network-security-group["location-name"]` (list)                                      | Network security groups for the various locations.           |
| `module.vnet["location-name"].azurerm_subnet.subnet_for_each` (list)                         | A list of subnets for each location in the virtual network.  |
| `module.vnet["location-name"].azurerm_subnet_network_security_group_association.vnet` (list) | Subnet and NSG associations for the virtual network.         |
| `module.vnet["location-name"].azurerm_virtual_network.vnet`                                  | Virtual network resource for the specified location.         |
| `module.vnet["location-name"].azurerm_subnet.subnet_for_each` (list)                         | A list of subnets for each location in the virtual network.  |
| `module.vnet["location-name"].azurerm_subnet_network_security_group_association.vnet` (list) | Subnet and NSG associations for the virtual network.         |
| `azurerm_virtual_network_peering.peering` (list)                                             | Peering connection between two Azure virtual networks.       |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the network resources will be created. | `string` | `null` | yes |
| <a name="input_vnet_location_primary"></a> [vnet\_location\_primary](#input\_vnet\_location\_primary) | The Azure region where the primary virtual network will be created. | `string` | `null` | yes |
| <a name="input_vnet_cidr_primary"></a> [vnet\_cidr\_primary](#input\_vnet\_cidr\_primary) | CIDR block for the primary virtual network. | `string` | `null` | yes |
| <a name="input_vnet_location_peered"></a> [vnet\_location\_peered](#input\_vnet\_location\_peered) | (Optional) The Azure region where the peered virtual network will be created, if deploying in dual region. | `string` | `null` | no |
| <a name="input_vnet_cidr_peered"></a> [vnet\_cidr\_peered](#input\_vnet\_cidr\_peered) | (Optional) CIDR block for the peered virtual network, if deploying in dual region. | `string` | `null` | no |
| <a name="input_users_access_cidr"></a> [users\_access\_cidr](#input\_users\_access\_cidr) | Allowed IPv4 address range for user access to CyberArk components. Must be a valid IP CIDR range of the form x.x.x.x/x. | `string` | `null` | yes |
| <a name="input_administrative_access_cidr"></a> [administrative\_access\_cidr](#input\_administrative\_access\_cidr) | Allowed IPv4 address range for administrative access to network resources. Must be a valid IP CIDR range of the form x.x.x.x/x. | `string` | `null` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rg_name"></a> [rg\_name](#output\_rg\_name) | Name of the Azure Resource Group. |
| <a name="output_rg_location"></a> [rg\_location](#output\_rg\_location) | Location of the Azure Resource Group. |
| <a name="output_vnet_location"></a> [vnet\_location](#output\_vnet\_location) | Locations of the primary and peered (if exists) virtual networks. |
| <a name="output_vault_subnet_id"></a> [vault\_subnet\_id](#output\_vault\_subnet\_id) | Subnet IDs for Vault |
| <a name="output_pvwa_subnet_id"></a> [pvwa\_subnet\_id](#output\_pvwa\_subnet\_id) | Subnet IDs for PVWA |
| <a name="output_cpm_subnet_id"></a> [cpm\_subnet\_id](#output\_cpm\_subnet\_id) | Subnet IDs for CPM |
| <a name="output_psm_subnet_id"></a> [psm\_subnet\_id](#output\_psm\_subnet\_id) | Subnet IDs for PSM |
| <a name="output_psmp_subnet_id"></a> [psmp\_subnet\_id](#output\_psmp\_subnet\_id) | Subnet IDs for PSMP |
| <a name="output_pta_subnet_id"></a> [pta\_subnet\_id](#output\_pta\_subnet\_id) | Subnet IDs for PTA |

<!-- END_TF_DOCS -->
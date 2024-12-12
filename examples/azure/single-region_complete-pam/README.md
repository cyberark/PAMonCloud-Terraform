# Complete PAM Solution

Configuration in this directory creates a networking environment and virtual machines of all PAM components (Primary Vault, Vault DR, PVWA, CPM, PSM, PSMP, PTA), deployed to function together. This setup is suitable for staging or production environments.

The setup includes the following components:
- Primary Vault (Located in the main region)
- Vault DR (deployed in a different availability zone to provide redundancy)
- PVWA (Password Vault Web Access)
- CPM (Central Policy Manager)
- PSM (Privileged Session Manager)
- PSMP (Privileged Session Manager Proxy)
- PTA (Privileged Threat Analytics)

Each component is deployed in a way that ensures they function together seamlessly.

## Usage

To run this example you need input the required variables, then execute:

```bash
terraform init
terraform plan
terraform apply
```

Note that this example creates resources which can cost money. Run `terraform destroy` when you don't need these resources.

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_pam_network"></a> [pam_network](#module\_pam\_network) | ../../../modules/azure/network/pam_network | n/a |
| <a name="module_vault"></a> [vault](#module\_vault) | ../../../modules/azure/components/vault | n/a |
| <a name="module_vault_dr"></a> [vault_dr](#module\_vault\_dr) | ../../../modules/azure/components/vault_dr | n/a |
| <a name="module_component"></a> [component](#module\_component) | ../../../modules/azure/components/component | n/a |

## Inputs

| Name | Description |
|------|-------------|
| <a name="input_vm_admin_password"></a> [vm\_admin\_password](#input\_vm\_admin\_password) | The administrator password for the virtual machine. |
| <a name="input_vault_master_password"></a> [vault\_master\_password](#input\_vault\_master\_password) | The master password for the vault. |
| <a name="input_vault_admin_password"></a> [vault\_admin\_password](#input\_vault\_admin\_password) | The administrator password for the vault. |
| <a name="input_vault_dr_password"></a> [vault\_dr\_password](#input\_vault\_dr\_password) | The disaster recovery password for the vault. |
| <a name="input_vault_dr_secret"></a> [vault\_dr\_secret](#input\_vault\_dr\_secret) | The disaster recovery secret for the vault. |
| <a name="input_storage_account_access_key"></a> [storage\_account\_access\_key](#input\_storage\_account\_access\_key) | The access key for the storage account. |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rg_name"></a> [rg\_name](#output\_rg\_name) | The name of the resource group. |
| <a name="output_rg_location"></a> [rg\_location](#output\_rg\_location) | The location of the resource group. |
| <a name="output_vnet_location"></a> [vnet\_location](#output\_vnet\_location) | The location of the virtual network. |
| <a name="output_subnet_to_vnet_map"></a> [subnet\_to\_vnet\_map](#output\_subnet\_to\_vnet\_map) | The mapping of subnets to virtual networks. |
| <a name="output_vault_subnet_id"></a> [vault\_subnet\_id](#output\_vault\_subnet\_id) | The ID of the vault subnet. |
| <a name="output_pvwa_subnet_id"></a> [pvwa\_subnet\_id](#output\_pvwa\_subnet\_id) | The ID of the PVWA subnet. |
| <a name="output_cpm_subnet_id"></a> [cpm\_subnet\_id](#output\_cpm\_subnet\_id) | The ID of the CPM subnet. |
| <a name="output_psm_subnet_id"></a> [psm\_subnet\_id](#output\_psm\_subnet\_id) | The ID of the PSM subnet. |
| <a name="output_psmp_subnet_id"></a> [psmp\_subnet\_id](#output\_psmp\_subnet\_id) | The ID of the PSMP subnet. |
| <a name="output_pta_subnet_id"></a> [pta\_subnet\_id](#output\_pta\_subnet\_id) | The ID of the PTA subnet. |
| <a name="output_vault_vm_private_ip"></a> [vault\_vm\_private\_ip](#output\_vault\_vm\_private\_ip) | The private IP address of the vault virtual machine. |
| <a name="output_vault_vm_name"></a> [vault\_vm\_name](#output\_vault\_vm\_name) | The name of the vault virtual machine. |
| <a name="output_vault_vm_availability_zone"></a> [vault\_vm\_availability\_zone](#output\_vault\_vm\_availability\_zone) | The availability zone of the vault virtual machine. |
| <a name="output_vault_dr_vm_private_ip"></a> [vault\_dr\_vm\_private\_ip](#output\_vault\_dr\_vm\_private\_ip) | The private IP address of the vault DR virtual machine. |
| <a name="output_vault_dr_vm_name"></a> [vault\_dr\_vm\_name](#output\_vault\_dr\_vm\_name) | The name of the vault DR virtual machine. |
| <a name="output_vault_dr_vm_availability_zone"></a> [vault\_dr\_vm\_availability\_zone](#output\_vault\_dr\_vm\_availability\_zone) | The availability zone of the vault DR virtual machine. |
| <a name="output_pvwa_private_ip"></a> [pvwa\_private\_ip](#output\_pvwa\_private\_ip) | The private IP address of the PVWA virtual machine. |
| <a name="output_pvwa_vm_name"></a> [pvwa\_vm\_name](#output\_pvwa\_vm\_name) | The name of the PVWA virtual machine. |
| <a name="output_cpm_private_ip"></a> [cpm\_private\_ip](#output\_cpm\_private\_ip) | The private IP address of the CPM virtual machine. |
| <a name="output_cpm_vm_name"></a> [cpm\_vm\_name](#output\_cpm\_vm\_name) | The name of the CPM virtual machine. |
| <a name="output_psm_private_ip"></a> [psm\_private\_ip](#output\_psm\_private\_ip) | The private IP address of the PSM virtual machine. |
| <a name="output_psm_vm_name"></a> [psm\_vm\_name](#output\_psm\_vm\_name) | The name of the PSM virtual machine. |
| <a name="output_psmp_private_ip"></a> [psmp\_private\_ip](#output\_psmp\_private\_ip) | The private IP address of the PSMP virtual machine. |
| <a name="output_psmp_vm_name"></a> [psmp\_vm\_name](#output\_psmp\_vm\_name) | The name of the PSMP virtual machine. |
| <a name="output_pta_private_ip"></a> [pta\_private\_ip](#output\_pta\_private\_ip) | The private IP address of the PTA virtual machine. |
| <a name="output_pta_vm_name"></a> [pta\_vm\_name](#output\_pta\_vm\_name) | The name of the PTA virtual machine. |

## Resources

### Retrieve information about a resource (post deployment)
You can use the `terraform state show` command followed by: `module.<module_name>.<resource_name>`  
Example: `terraform state show 'module.psm_vm.azurerm_network_interface.component_network_interface'`  
For list objects, you can use `terraform state list` to get all objects within the list.

### Network Resources
| Resource                                                                                     | Description                                                  | Module                         |
|----------------------------------------------------------------------------------------------|-----------------------------------------------------------   |--------------------------------|
| `azurerm_network_interface.component_network_interface`                                      | The network interface for the component virtual machine.     | [Component VMs](#component-vms)|
| `data.azurerm_subnet.subnet_map` (list)                                                      | A list of subnets used in the network configuration.         | pam-network                    |
| `azurerm_network_security_rule.nsg_rules_per_location` (list)                                | Network security rules associated with each location.        | pam-network                    |
| `azurerm_resource_group.pamoncaloud_rg`                                                      | The resource group used for the PAM network setup.           | pam-network                    |
| `azurerm_key_vault.vault_dr_key_vault`                                                       | The key vault for Vault DR (Disaster Recovery).              | vault_dr_vm                    |
| `azurerm_network_interface.vault_dr_network_interface`                                       | The network interface for the Vault DR virtual machine.      | vault_dr_vm                    |
| `azurerm_key_vault.primary_vault_key_vault`                                                  | The key vault for the primary Vault VM.                      | vault_vm                       |
| `azurerm_network_interface.primary_vault_network_interface`                                  | The network interface for the primary Vault virtual machine. | vault_vm                       |
| `module.network-security-group` (list)                                                       | Network security groups for the various locations.           | pam-network                    |
| `module.vnet["location-name"].azurerm_subnet.subnet_for_each` (list)                         | A list of subnets for each location in the virtual network.  | pam-network                    |
| `module.vnet["location-name"].azurerm_subnet_network_security_group_association.vnet` (list) | Subnet and NSG associations for the virtual network.         | pam-network                    |
| `module.vnet["location-name"].azurerm_virtual_network.vnet`                                  | Virtual network resource for the specified location.         | pam-network                    |
| `module.vnet["location-name"].azurerm_subnet.subnet_for_each` (list)                         | A list of subnets for each location in the virtual network.  | pam-network                    |
| `module.vnet["location-name"].azurerm_subnet_network_security_group_association.vnet` (list) | Subnet and NSG associations for the virtual network.         | pam-network                    |

### VM Resources
| Resource                                                           | Description                                                               | Module                          |
|--------------------------------------------------------------------|---------------------------------------------------------------------------|---------------------------------|
| `azurerm_virtual_machine.windows_component_vm[0]`                  | The Windows virtual machine for the component.                            | [Component VMs](#component-vms) |
| `azurerm_virtual_machine_extension.windows_registration_script[0]` | The Windows registration script for the virtual machine extension.        | [Component VMs](#component-vms) |
| `azurerm_virtual_machine.vault_dr_vm`                              | The Vault DR virtual machine for disaster recovery.                       | vault_dr_vm                     |
| `azurerm_virtual_machine_extension.registration_script`            | The registration script for the Vault DR VM.                              | [Vault VMs](#vault-vms)         |
| `azurerm_virtual_machine.primary_vault_vm`                         | The primary Vault virtual machine.                                        | vault_vm                        |
| `azurerm_virtual_machine.primary_vault_vm`                         | The main Vault virtual machine (primary).                                 | vault_vm                        |
| `data.azurerm_virtual_machine.vault_vm_data`                       | Data about the Vault VM, used for additional configuration or management. | [Vault VMs](#vault-vms)         |

#### **Miscellaneous**
| Resource                    | Description                                    | Module              |
|-----------------------------|------------------------------------------------|---------------------|
| `random_uuid.random_suffix` | A randomly generated suffix for unique naming. | [All VMs](#all-vms) |

### Each nickname includes the following modules

<a name="vault-vms"></a>
**_Vault VMs_**:  
   `vault_vm`, `vault_dr_vm`

<a name="component-vms"></a>
**_Component VMs_**:  
   `pvwa_vm`, `cpm_vm`, `psm_vm`, `psmp_vm`, `pta_vm`

<a name="all-vms"></a>
**_All VMs_**:  
   `vault_vm`, `vault_dr_vm`, `pvwa_vm`, `cpm_vm`, `psm_vm`, `psmp_vm`, `pta_vm`

<!-- END_TF_DOCS -->
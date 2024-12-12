# PAMonCloud for Azure - Component Terraform Module

This module deploys and manages PAM components like **PVWA**, **CPM**, **PSM**, **PSMP**, and **PTA** as Azure Virtual Machines. It supports custom VM configurations and integrates seamlessly with Azure networking (VNETs, Subnets), Azure Monitor for logging, and Azure Functions for enhanced automation and functionality.

## Usage

See [`examples`](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/azure) directory for working examples to reference:

The following example demonstrates how to use the `component` module to deploy a PAM component VM. This example can be adapted for components such as **PVWA**, **CPM**, **PSM**, **PSMP**, and **PTA** by changing the `component` value to the respective component name.

```hcl
module "component_vm" {
    source       = "../../modules/components/component"

    vm_name                 = "PAMonCloud-component
    vm_hostname             = "component"
    vm_size                 = "Standard_D8s_v3"
    resource_group_name     = "ResourceGroupName"
    location                = "westeurope"
    availability_zone       = ["1"]
    subnet_id               = "/subscriptions/12345678-1234-5678-1234-567812345678/resourceGroups/PAM-Network/providers/Microsoft.Network/virtualNetworks/PAM-VNet/subnets/Component-Subnet"
    vm_admin_user           = "azureadmin"
    vm_admin_password       = "SecureP@ssw0rd!13"
    image_id                = "/subscriptions/12345678-1234-5678-1234-567812345678/resourceGroups/PAM-Images/providers/Microsoft.Compute/images/Component-Image"
    component               = "PVWA" // valid option : "PVWA", "CPM", "PSM", "PSMP", "PTA".
    primary_vault_private_ip = "10.0.1.10"
    vault_admin_username    = "Administrator"
    vault_admin_password    = "AdminVaultP@ss!5"
    vault_dr_private_ip     = "10.0.2.10"
    pvwa_vm_hostname        = "pvwa"
}
```

## Examples

- [single-region_complete-pam](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/azure/single-region_complete-pam) with Component.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.8 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.116.0 |

## Modules

No modules.

## Resources

### Retrieve information about a resource (post deployment)
You can use the `terraform state show` command followed by: `module.<module_name>.<resource_name>`  
Example: `terraform state show 'module.component_vm.azurerm_network_interface.component_network_interface'`  

#### **Network Interfaces**
| Resource                                                | Description                                              |
|---------------------------------------------------------|----------------------------------------------------------|
| `azurerm_network_interface.component_network_interface` | The network interface for the component virtual machine. |

#### **Virtual Machines**
| Resource                                          | Description                                    |
|---------------------------------------------------|------------------------------------------------|
| `azurerm_virtual_machine.component_vm[0]` | The virtual machine for the component. |

#### **VM Extensions**
| Resource                                                           | Description                                                        |
|--------------------------------------------------------------------|--------------------------------------------------------------------|
| `azurerm_virtual_machine_extension.registration_script[0]` | The registration script for the virtual machine extension. |

#### **Random Resources**
| Resource                     | Description                                    |
|------------------------------|------------------------------------------------|
| `random_uuid.random_suffix`  | A randomly generated suffix for unique naming. |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | The name of the virtual machine. | `string` | `null` | yes |
| <a name="input_vm_hostname"></a> [vm\_hostname](#input\_vm\_hostname) | The hostname of the virtual machine. Must be 3 to 15 characters long, contain at least one letter, and must not start or end with a hyphen.  | `string` | `null` | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the virtual machine (e.g., Standard_D8s_v3). | `string` | `null` | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group. Must be between 1 and 90 characters long, start with a letter and contain only alphanumeric characters, underscores, hyphens or parentheses | `string` | `null` | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the virtual machine will be deployed , lowercase letters only. | `string` | `null` | yes |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | The availability zone for the virtual machine. | `list(string)` | `null` | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet where the VM will be deployed. In the following format : /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName} | `string` | `null` | yes |
| <a name="input_vm_admin_user"></a> [vm\_admin\_user](#input\_vm\_admin\_user) | The administrator username for the virtual machine. | `string` | `null` | yes |
| <a name="input_vm_admin_password"></a> [vm\_admin\_password](#input\_vm\_admin\_password) | The administrator password for the virtual machine. | `string` | `null` | yes |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The image ID to use for creating the virtual machine. In the following format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName} | `string` | `null` | yes |
| <a name="input_component"></a> [component](#input\_component) | The name of the PAM component. Allowed components are: PVWA, CPM, PSM, PSMP, PTA. | `string` | `null` | yes |
| <a name="input_primary_vault_private_ip"></a> [primary\_vault\_private\_ip](#input\_primary\_vault\_private\_ip) | The private IP address of the primary vault. | `string` | `null` | yes |
| <a name="input_vault_admin_username"></a> [vault\_admin\_username](#input\_vault\_admin\_username) | The administrator username for the vault. | `string` | `null` | yes |
| <a name="input_vault_admin_password"></a> [vault\_admin\_password](#input\_vault\_admin\_password) | The administrator password for the vault. | `string` | `null` | yes |
| <a name="input_vault_dr_private_ip"></a> [vault\_dr\_private\_ip](#input\_vault\_dr\_private\_ip) | The private IP address of the DR Vault.(if exists) | `string` | `null` | no |
| <a name="input_pvwa_vm_hostname"></a> [pvwa\_vm\_hostname](#input\_pvwa\_vm\_hostname) | The hostname of the PVWA VM. (Required only when component is PTA) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | The private IP address of the network interface. |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | The name of the virtual machine deployed. |
| <a name="output_vm_hostname"></a> [vm\_hostname](#output\_vm\_hostname) | The hostname of the virtual machine as provided by input variable. |

<!-- END_TF_DOCS -->
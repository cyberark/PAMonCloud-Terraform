# PAMonCloud for Azure - Vault Terraform Module

This module is used to deploy and manage a **Vault** VM within an Azure environment. It provisions a virtual machine for Vault, integrates with Azure networking, and handles configuration related to Vault's license, recovery keys, and additional Azure Functions.

## Usage

See [`examples`](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/azure) directory for working examples to reference:

```hcl
module "vault_vm" {
    source       = "../../../modules/azure/components/vault"

    vm_name = "PrimaryVault"
    vm_hostname = "vault"
    vm_size = "Standard_D8s_v3"
    resource_group_name = "ResourceGroupName"
    location = ""westeurope""
    availability_zone = ["1"]
    subnet_id = {
      primary   = "/subscriptions/abcd1234-abcd-1234-5678-efghijklmnop/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/subnet-primary"
      peered    = "/subscriptions/abcd1234-abcd-1234-5678-efghijklmnop/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/subnet-peered"
    }
    vm_admin_user = "azureadmin"
    vm_admin_password = "VaultAdminPassword"
    image_id = "/subscriptions/12345678-1234-5678-1234-567812345678/resourceGroups/PAM-Images/providers/Microsoft.Compute/images/Component-Image"
    storage_account_name = "StorageAccount"
    storage_account_access_key = "access-key"
    container_name = "ContainerName"
    license_file = "license.xml"
    recovery_public_key_file = "recpub.key"
    key_vault_name = "key-vault"
    vault_master_password          = "VaultMasterPassword"
    vault_admin_password           = "VaultAdminPassword"
    vault_dr_password              = "VaultDrPassword"
    vault_dr_secret                = "VaultDrSecret"
}
```

## Examples

- [single-region_complete-pam](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/azure/single-region_complete-pam) with Vault.

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
Example: `terraform state show 'module.vault_vm.azurerm_key_vault.primary_vault_key_vault'`  

### Network Resources
| Resource                                                                                     | Description                                                  |
|----------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `azurerm_key_vault.primary_vault_key_vault`                                                  | The key vault for the primary Vault VM.                      |
| `azurerm_network_interface.primary_vault_network_interface`                                  | The network interface for the primary Vault virtual machine. |

### VM Resources
| Resource                                                           | Description                                                               |
|--------------------------------------------------------------------|---------------------------------------------------------------------------|
| `azurerm_virtual_machine.valut_dr_vm`                              | The Vault DR virtual machine for disaster recovery.                       |
| `azurerm_virtual_machine_extension.registration_script`            | The registration script for the Vault DR VM.                              |
| `azurerm_virtual_machine.primary_valut_vm`                         | The primary Vault virtual machine.                                        |
| `data.azurerm_virtual_machine.vault_vm_data`                       | Data about the Vault VM, used for additional configuration or management. |

#### **Miscellaneous**
| Resource                    | Description                                    |
|-----------------------------|------------------------------------------------|
| `random_uuid.random_suffix` | A randomly generated suffix for unique naming. | 

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | The name of the VM. | `string` | `null` | yes |
| <a name="input_vm_hostname"></a> [vm\_hostname](#input\_vm\_hostname) | The hostname for the VM. Must be 3 to 15 characters long, contain at least one letter, and must not start or end with a hyphen. | `string` | `null` | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the VM (e.g., Standard_D8s_v3). Valid options include: Standard_D8s_v3, Standard_D16s_v3, Standard_D32s_v3, Standard_D64s_v3, Standard_F8s_v2, Standard_F16s_v2, Standard_F32s_v2. | `string` | `null` | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group. Must be between 1 and 90 characters long, start with a letter, and contain only alphanumeric characters, underscores, hyphens, or parentheses. | `string` | `null` | yes |
| <a name="input_location"></a> [location](#input\_location) | The location to deploy the VM. Must be a valid Azure region name matching lowercase letters, alphanumerics, and hyphens only. | `string` | `null` | yes |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | The availability zone of the VM. Can be an empty list or a list with values "1", "2", or "3". | `list(string)` | `["1"]` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID where the Vault VM can reside. Must follow Azure subnet ID format. | `type = object({ primary = string peered = optional(string)})` | `null` | yes |
| <a name="input_vm_admin_user"></a> [vm\_admin\_user](#input\_vm\_admin\_user) | Admin username for the VM. Must only contain alphanumerics, underscores, periods, or hyphens. Reserved usernames such as Administrator, Guest, and System cannot be used. | `string` | `null` | yes |
| <a name="input_vm_admin_password"></a> [vm\_admin\_password](#input\_vm\_admin\_password) | Admin password for the VM. Password must be between 12 and 123 characters long, must contain at least one uppercase letter, one lowercase letter, one number, and one special character. | `string` | `null` | yes |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | VM image ID. Must follow the Azure image resource ID format. | `string` | `null` | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the storage account which hosts the container with the Vault license and recovery key. Must adhere to Azure naming conventions. | `string` | `null` | yes |
| <a name="input_storage_account_access_key"></a> [storage\_account\_access\_key](#input\_storage\_account\_access\_key) | The access key for the storage account that contains the Vault license and recovery key. Must contain only Base64 characters. | `string` | `null` | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | The name of the container in the storage account where Vault license and recovery key are stored. Must follow Azure naming conventions. | `string` | `null` | yes |
| <a name="input_license_file"></a> [license\_file](#input\_license\_file) | The name of the license file stored in the storage account container. | `string` | `"license.xml"` | no |
| <a name="input_recovery_public_key_file"></a> [recovery\_public\_key\_file](#input\_recovery\_public\_key\_file) | The name of the recovery public key file stored in the storage account container. | `string` | `"recpub.key"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the key vault. Must adhere to Azure naming conventions. | `string` | `null` | yes |
| <a name="input_vault_master_password"></a> [vault\_master\_password](#input\_vault\_master\_password) | Primary Vault Master Password. Must have at least 10 characters, with one uppercase, one lowercase, one special character, and one digit. | `string` | `null` | yes |
| <a name="input_vault_admin_password"></a> [vault\_admin\_password](#input\_vault\_admin\_password) | Primary Vault Admin Password. Must have at least 10 characters, with one uppercase, one lowercase, one special character, and one digit. | `string` | `null` | yes |
| <a name="input_vault_dr_password"></a> [vault\_dr\_password](#input\_vault\_dr\_password) | Vault DR user password. Must have at least 10 characters, with one uppercase, one lowercase, one special character, and one number. | `string` | `null` | yes |
| <a name="input_vault_dr_secret"></a> [vault\_dr\_secret](#input\_vault\_dr\_secret) | Vault DR user secret. Required only for DR implementations. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | The private IP address of the network interface. |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | The name of the virtual machine deployed. |
| <a name="output_availability_zone"></a> [availability\_zone](#output\_availability\_zone) | The availability zone |

<!-- END_TF_DOCS -->
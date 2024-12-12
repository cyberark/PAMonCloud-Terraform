# Single PAM Component Deployment on Azure

Configuration in this directory facilitates the deployment of a single PAM component (e.g., PVWA, CPM, PSM, PSMP, PTA). This setup is ideal for environments where individual PAM modules need to be deployed separately, or added to an existing environment.

The deployment options include:
- PVWA (Password Vault Web Access)
- CPM (Central Policy Manager)
- PSM (Privileged Session Manager)
- PSMP (Privileged Session Manager Proxy)
- PTA (Privileged Threat Analytics)

This configuration deploys the selected component independently, ensuring it operates effectively within an existing PAM environment.

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
| <a name="module_component"></a> [component](#module\_component) | ../../../modules/azure/components/component | n/a |

## Inputs

| Name | Description |
|------|-------------|
| <a name="input_component"></a> [component](#input\_component) | The name of the PAM component. |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the component is deployed. |
| <a name="input_vault_admin_password"></a> [vault\_admin\_password](#input\_vault\_admin\_password) | The administrator password for the vault. (Sensitive) |
| <a name="input_primary_vault_private_ip"></a> [primary\_vault\_private\_ip](#input\_primary\_vault\_private\_ip) | The private IP address of the primary vault. (Sensitive) |
| <a name="input_vault_dr_private_ip"></a> [vault\_dr\_private\_ip](#input\_vault\_dr\_private\_ip) | The IP address of the Vault DR virtual machine. Required only when the component is PTA. |
| <a name="input_pvwa_vm_hostname"></a> [pvwa\_vm\_hostname](#input\_pvwa\_vm\_hostname) | The name of the PVWA virtual machine. Required only when the component is PTA. |
| <a name="input_component_vm_admin_password"></a> [component\_vm\_admin\_password](#input\_component\_vm\_admin\_password) | The administrator password for the component virtual machine. (Sensitive) |
| <a name="input_component_subnet_id"></a> [component\_subnet\_id](#input\_component\_subnet\_id) | The ID of the subnet in which the component virtual machine will be deployed. |
| <a name="input_component_location"></a> [component\_location](#input\_component\_location) | The location of the component. |
| <a name="input_component_availability_zone"></a> [component\_availability\_zone](#input\_component\_availability\_zone) | The availability zone of the component. |
| <a name="input_component_image_id"></a> [component\_image\_id](#input\_component\_image\_id) | The image ID for the component virtual machine. |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_component_private_ip"></a> [component\_private\_ip](#output\_component\_private\_ip) | The private IP address of the network interface. |
| <a name="output_component_vm_name"></a> [component\_vm\_name](#output\_component\_vm\_name) | The name of the virtual machine. |

## Resources

### Retrieve information about a resource (post deployment)
You can use the `terraform state show` command followed by: `module.<module_name>.<resource_name>`  
Example: `terraform state show 'module.psm_vm.azurerm_network_interface.component_network_interface'`  

#### **Network Interfaces**
| Resource                                                | Description                                              |
|---------------------------------------------------------|----------------------------------------------------------|
| `azurerm_network_interface.component_network_interface` | The network interface for the component virtual machine. |

#### **Virtual Machines**
| Resource                                          | Description                                    |
|---------------------------------------------------|------------------------------------------------|
| `azurerm_virtual_machine.windows_component_vm[0]` | The Windows virtual machine for the component. |

#### **VM Extensions**
| Resource                                                           | Description                                                        |
|--------------------------------------------------------------------|--------------------------------------------------------------------|
| `azurerm_virtual_machine_extension.windows_registration_script[0]` | The Windows registration script for the virtual machine extension. |

#### **Random Resources**
| Resource                     | Description                                    |
|------------------------------|------------------------------------------------|
| `random_uuid.random_suffix`  | A randomly generated suffix for unique naming. |

<!-- END_TF_DOCS -->
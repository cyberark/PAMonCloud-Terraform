# PAMonCloud for AWS - Dual Region - Vault with DR Deployment

Configuration in this directory creates a networking environment and EC2 instances of Vault and Vault DR, deployed to function together. This setup is suitable for staging or production environments.

The setup includes the following components:
- Primary Vault (Located in the main region)
- Vault DR (deployed in a secondary region to provide geographic redundancy)

The components is configured to work together, with the Vault DR positioned in a separate region to enhance disaster recovery capabilities.

## Usage

To run this example you need input the required variables, then execute:

```bash
terraform init
terraform plan
terraform apply
```

Note that this example creates resources which can cost money (AWS EC2 Instance, for example). Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.73.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_pam_network"></a> [pam_network](#module\_pam\_network) | ../../../modules/aws/network/pam_network | n/a |
| <a name="module_pam_network_peering"></a> [pam_network_peering](#module\_pam\_network\_peering) | ../../../modules/aws/network/pam_network_peering | n/a |
| <a name="module_deploy_prerequisites"></a> [deploy_prerequisites](#module\_deploy\_prerequisites) | ../../../modules/aws/components/deploy_prerequisites | n/a |
| <a name="module_vault"></a> [vault](#module\_vault) | ../../../modules/aws/components/vault | n/a |
| <a name="module_vault_dr"></a> [vault_dr](#module\_vault\_dr) | ../../../modules/aws/components/vault_dr | n/a |

## Inputs

| Name | Description |
|------|-------------|
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the EC2 key pair to use. |
| <a name="input_vault_master_password"></a> [vault\_master\_password](#input\_vault\_master\_password) | Primary Vault Master Password. |
| <a name="input_vault_admin_password"></a> [vault\_admin\_password](#input\_vault\_admin\_password) | Primary Vault Admin Password. |
| <a name="input_vault_dr_password"></a> [vault\_dr\_password](#input\_vault\_dr\_password) | Primary Vault DR Password. |
| <a name="input_vault_dr_secret"></a> [vault\_dr\_secret](#input\_vault\_dr\_secret) | Primary Vault DR Secret. (Required only for DR implementations)|
| <a name="input_vault_files_bucket"></a> [vault\_files\_bucket](#input\_vault\_files\_bucket) | The name of the S3 bucket where Vault license and recovery key are stored. |
| <a name="input_vault_custom_ami_id"></a> [vault\_custom\_ami\_id](#input\_vault\_custom\_ami\_id) | Custom AMI ID to use instead of the default one. (Optional) |
| <a name="input_vault_dr_custom_ami_id"></a> [vault\_dr\_custom\_ami\_id](#input\_vault\_dr\_custom\_ami\_id) | Custom AMI ID to use instead of the default one. (Optional) |

## Outputs

| Name | Module | Description |
|------|--------|-------------|
| <a name="output_vpc_id_main"></a> [vpc\_id\_main](#output\_vpc\_id\_main) | pam_network_main | VPC ID - Main Region. |
| <a name="output_vpc_id_dr"></a> [vpc\_id\_dr](#output\_vpc\_id\_dr) | pam_network_dr | VPC ID - DR Region. |
| <a name="output_public_subnets_main"></a> [public\_subnets\_main](#output\_public\_subnets\_main) | pam_network_main | Public Subnet IDs - Main Region. |
| <a name="output_public_subnets_dr"></a> [public\_subnets\_dr](#output\_public\_subnets\_dr) | pam_network_dr | Public Subnet IDs - DR Region. |
| <a name="output_public_route_table_ids_main"></a> [public\_route\_table\_ids\_main](#output\_public\_route\_table\_ids\_main) | pam_network_main | Public route tables IDs - Main Region. |
| <a name="output_public_route_table_ids_dr"></a> [public\_route\_table\_ids\_dr](#output\_public\_route\_table\_ids\_dr) | pam_network_dr | Public route tables IDs - DR Region. |
| <a name="output_private_route_table_ids_main"></a> [private\_route\_table\_ids\_main](#output\_private\_route\_table\_ids\_main) | pam_network_main | Private route tables IDs - Main Region. |
| <a name="output_private_route_table_ids_dr"></a> [private\_route\_table\_ids\_dr](#output\_private\_route\_table\_ids\_dr) | pam_network_dr | Private route tables IDs - DR Region. |
| <a name="output_natgw_ids_main"></a> [natgw\_ids\_main](#output\_natgw\_ids\_main) | pam_network_main | List of NAT Gateway IDs - Main Region. |
| <a name="output_natgw_ids_dr"></a> [natgw\_ids\_dr](#output\_natgw\_ids\_dr) | pam_network_dr | List of NAT Gateway IDs - DR Region. |
| <a name="output_security_group_ids_main"></a> [security\_group\_ids\_main](#output\_security\_group\_ids\_main) | pam_network_main | Security Group IDs for all components - Main Region. |
| <a name="output_security_group_ids_dr"></a> [security\_group\_ids_dr](#output\_security\_group\_ids\_dr) | pam_network_dr | Security Group IDs for all components - DR Region. |
| <a name="output_private_subnets_map_main"></a> [private\_subnets\_map\_main](#output\_private\_subnets\_map\_main) | pam_network_main | A map of subnet details (id and cidr_block) by name - Main Region. |
| <a name="output_private_subnets_map_dr"></a> [private\_subnets\_map\_dr](#output\_private\_subnets\_map\_dr) | pam_network_dr | A map of subnet details (id and cidr_block) by name - DR Region. |
| <a name="output_deployment_uid"></a> [deployment\_uid](#output\_deployment\_uid) | deploy_prerequisites | Deployment Unique ID. |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | deploy_prerequisites | CloudWatch Log Group name. |
| <a name="output_vault_instance_ip_address"></a> [vault\_instance\_ip\_address](#output\_vault\_instance\_ip\_address) | vault | Vault instance IP address. |
| <a name="output_vault_instance_private_dns"></a> [vault\_instance\_private\_dns](#output\_vault\_instance\_private\_dns) | vault | Vault instance private DNS. |
| <a name="output_vault_instance_id"></a> [vault\_instance\_id](#output\_vault\_instance\_id) | vault | Vault instance ID. |
| <a name="output_vault_instance_hostname"></a> [vault\_instance\_hostname](#output\_vault\_instance\_hostname) | vault | Vault instance hostname. |
| <a name="output_vault_dr_instance_ip_address"></a> [vault\_dr\_instance\_ip\_address](#output\_vault\_dr\_instance\_ip\_address) | vault_dr | Vault DR instance IP address. |
| <a name="output_vault_dr_instance_private_dns"></a> [vault\_dr\_instance\_private\_dns](#output\_vault\_dr\_instance\_private\_dns) | vault_dr | Vault DR instance private DNS. |
| <a name="output_vault_dr_instance_id"></a> [vault\_dr\_instance\_id](#output\_vault\_dr\_instance\_id) | vault_dr | Vault DR instance ID. |
| <a name="output_vault_dr_instance_hostname"></a> [vault\_dr\_instance\_hostname](#output\_vault\_dr\_instance\_hostname) | vault_dr | Vault DR instance hostname. |
| <a name="output_peering_connection_request_id"></a> [peering\_connection\_request\_id](#output\_peering\_connection\_request\_id) | peering_connection_request | Peering connection request ID. |

## Resources

### Retrieve information about a resource (post deployment)
You can use the `terraform state show` command followed by: `module.<module_name>.<resource_name>`  
Example: `terraform state show 'module.vault_instance.data.aws_ami.vault_ami'`  
For list objects, you can use `terraform state list` to get all objects within the list.

#### **EC2 Instances**
| Resource                              | Description                                    | Module                                       |
|---------------------------------------|------------------------------------------------|----------------------------------------------|
| `aws_instance.vault`                  | Primary Vault EC2 instance resource.           | vault_instance                               |
| `aws_instance.vault_dr`               | DR Vault EC2 instance resource.                | vault_dr_instance                            |

#### **CloudWatch Resources**
| Resource                                                      | Description                                                | Module                               |
|---------------------------------------------------------------|------------------------------------------------------------|--------------------------------------|
| `aws_cloudwatch_log_group.log_group`                          | CloudWatch log group.                                      | deploy_prep_main, deploy_prep_dr     |
| `aws_cloudwatch_log_stream.additional_log_streams` (list)     | CloudWatch log streams for additional configuration.       | [Vault Instances](#vault-instances)  |
| `aws_cloudwatch_log_stream.user_data_log_stream`              | CloudWatch log stream for user data logs.                  | [Vault Instances](#vault-instances)  |

#### **IAM Roles/Policies**
| Resource                                                                                 | Description                                                     | Module                              |
|------------------------------------------------------------------------------------------|-----------------------------------------------------------------|-------------------------------------|
| `aws_iam_instance_profile.instance_profile`                                              | IAM instance profile.                                           | [Vault Instances](#vault-instances) |
| `aws_iam_role.instance_role`                                                             | IAM role for the instance.                                      | [Vault Instances](#vault-instances) |
| `aws_iam_role.lambda_manage_ssm_password_role`                                           | IAM role for managing SSM password in Lambda.                   | deploy_prep_main, deploy_prep_dr    |
| `aws_iam_role.lambda_remove_permissions_role`                                            | IAM role for removing permissions in Lambda.                    | deploy_prep_main, deploy_prep_dr    |
| `aws_iam_role.lambda_retrieve_success_signal_role`                                       | IAM role for retrieving success signal in Lambda.               | deploy_prep_main, deploy_prep_dr    |
| `aws_iam_role_policy.instance_cloudwatch_policy`                                         | IAM policy for CloudWatch logging.                              | [Vault Instances](#vault-instances) |
| `aws_iam_role_policy.instance_kms_policy`                                                | IAM policy for AWS KMS.                                         | [Vault Instances](#vault-instances) |
| `aws_iam_role_policy.instance_s3_policy`                                                 | IAM policy for S3 access.                                       | [Vault Instances](#vault-instances) |
| `aws_iam_role_policy.instance_ssm_policy`                                                | IAM policy for SSM management.                                  | [Vault Instances](#vault-instances) |
| `aws_iam_role_policy.lambda_manage_ssm_password_policy`                                  | IAM policy for managing SSM password in Lambda.                 | deploy_prep_main, deploy_prep_dr    |
| `aws_iam_role_policy.lambda_remove_permissions_policy`                                   | IAM policy for removing permissions via Lambda.                 | [Vault Instances](#vault-instances) |
| `aws_iam_role_policy.lambda_retrieve_success_signal_policy`                              | IAM policy for retrieving success signal in Lambda.             | deploy_prep_main, deploy_prep_dr    |
| `aws_iam_role_policy_attachment.instance_ssm_managed_policy`                             | IAM role policy attachment for AWS managed SSM policy.          | [Vault Instances](#vault-instances) |
| `aws_iam_role_policy_attachment.lambda_manage_ssm_password_execution_managed_policy`     | IAM policy attachment for Lambda to manage SSM password.        | deploy_prep_main, deploy_prep_dr    |
| `aws_iam_role_policy_attachment.lambda_remove_permissions_execution_managed_policy`      | IAM policy attachment for Lambda to remove permissions.         | deploy_prep_main, deploy_prep_dr    |
| `aws_iam_role_policy_attachment.lambda_retrieve_success_signal_execution_managed_policy` | IAM policy attachment for Lambda to retrieve success signal.    | deploy_prep_main, deploy_prep_dr    |
| `data.aws_iam_policy_document.instance_assume_role_policy`                               | IAM policy document defining instance assume role policy.       | [Vault Instances](#vault-instances) |
| `data.aws_iam_policy_document.lambda_assume_role_policy`                                 | IAM policy document for Lambda assume role.                     | deploy_prep_main, deploy_prep_dr    |
| `data.aws_iam_policy_document.lambda_remove_permissions_policy`                          | IAM policy document for removing permissions via Lambda.        | [Vault Instances](#vault-instances) |

#### **Lambda Resources**
| Resource                                             | Description                                                   | Module                                                       |
|------------------------------------------------------|---------------------------------------------------------------|--------------------------------------------------------------|
| `aws_lambda_function.manage_ssm_password_lambda`     | Lambda for managing SSM password.                             | deploy_prep_main, deploy_prep_dr                             |
| `aws_lambda_function.remove_permissions_lambda`      | Lambda for removing permissions.                              | deploy_prep_main, deploy_prep_dr                             |
| `aws_lambda_function.retrieve_success_signal_lambda` | Lambda for retrieving success signal.                         | deploy_prep_main, deploy_prep_dr                             |
| `aws_lambda_invocation.remove_admin_password`	       | Lambda invocation for removing admin password.	               | vault_instance                                               |
| `aws_lambda_invocation.remove_dr_password`           | Lambda invocation for removing DR password.                   | [Vault Instances](#vault-instances)                          |
| `aws_lambda_invocation.remove_dr_secret[0]`          | Lambda invocation for removing DR secret.                     | [Vault Instances](#vault-instances)                          |
| `aws_lambda_invocation.remove_master_password`       | Lambda invocation for removing master password.               | [Vault Instances](#vault-instances)                          |
| `aws_lambda_invocation.remove_permissions`           | Lambda invocation for removing deployment temp permissions.   | [Vault Instances](#vault-instances)                          |
| `aws_lambda_invocation.store_admin_password`	       | Lambda invocation for storing admin password.	               | vault_instance                                               |
| `aws_lambda_invocation.store_dr_password`            | Lambda invocation for storing DR password.                    | [Vault Instances](#vault-instances)                          |
| `aws_lambda_invocation.store_dr_secret[0]`           | Lambda invocation for storing DR secret.                      | [Vault Instances](#vault-instances)                          |
| `aws_lambda_invocation.store_master_password`        | Lambda invocation for storing master password.                | [Vault Instances](#vault-instances)                          |
| `aws_lambda_invocation.wait_for_userdata_completion` | Lambda invocation to monitor user data completion.            | [Vault Instances](#vault-instances)                          |

#### **Network and Security**
| Resource                                                     | Description                                                  | Module                                                |
|--------------------------------------------------------------|--------------------------------------------------------------|-------------------------------------------------------|
| `aws_network_acl.vault_nacl`                                 | Vault network ACL.                                           | pam_network_main, pam_network_dr                      |
| `aws_route.vpc_peering_route`                                | VPC peering route                                            | peering_connection_request, peering_connection_accept |
| `aws_security_group.security_group` (list)                   | List of Security groups for all instances.                   | pam_network_main, pam_network_dr                      |
| `aws_security_group_rule.peering_rules` (list)               | Security group rule in the peering connection module.        | peering_connection_request, peering_connection_accept |
| `aws_security_group_rule.rules_with_cidr` (list)             | List of security group rules with CIDR blocks.               | pam_network_main, pam_network_dr                      |
| `aws_vpc_peering_connection.pcx_main[0]`                     | VPC peering connection requester                             | peering_connection_request                            |
| `aws_vpc_peering_connection_accepter.pcx_peer[0]`            | VPC peering connection accepter                              | peering_connection_accept                             |
| `module.pam_vpc.aws_default_network_acl.this[0]`             | Default network ACL for the VPC.                             | pam_network_main, pam_network_dr                      |
| `module.pam_vpc.aws_default_route_table.default[0]`          | Default route table for the VPC.                             | pam_network_main, pam_network_dr                      |
| `module.pam_vpc.aws_default_security_group.this[0]`          | Default security group for the VPC.                          | pam_network_main, pam_network_dr                      |
| `module.pam_vpc.aws_eip.nat[0]`                              | Elastic IP for the NAT gateway.                              | pam_network_main, pam_network_dr                      |
| `module.pam_vpc.aws_internet_gateway.this[0]`                | Internet gateway for the VPC.                                | pam_network_main, pam_network_dr                      |
| `module.pam_vpc.aws_nat_gateway.this[0]`                     | NAT gateway for the VPC.                                     | pam_network_main, pam_network_dr                      |
| `module.pam_vpc.aws_route.private_nat_gateway[0]`            | Route for private subnets to the NAT gateway.                | pam_network_main, pam_network_dr                      |
| `module.pam_vpc.aws_route.public_internet_gateway[0]`        | Route for public subnets to the internet gateway.            | pam_network_main, pam_network_dr                      |
| `module.pam_vpc.aws_route_table.private[0]`                  | Route table for private subnets.                             | pam_network_main, pam_network_dr                      |
| `module.pam_vpc.aws_route_table.public[0]`                   | Route table for public subnets.                              | pam_network_main, pam_network_dr                      |
| `module.pam_vpc.aws_route_table_association.private` (list)  | List of route table associations for private subnets.        | pam_network_main, pam_network_dr                      |
| `module.pam_vpc.aws_route_table_association.public[0]`       | Route table association for public subnets.                  | pam_network_main, pam_network_dr                      |
| `module.pam_vpc.aws_subnet.private` (list)                   | List of private subnets.                                     | pam_network_main, pam_network_dr                      |
| `module.pam_vpc.aws_subnet.public[0]`                        | Public subnet.                                               | pam_network_main, pam_network_dr                      |
| `module.pam_vpc.aws_vpc.this[0]`                             | The VPC resource.                                            | pam_network_main, pam_network_dr                      |

#### **Miscellaneous**
| Resource                                          | Description                                                 | Module                                                                |
|---------------------------------------------------|-------------------------------------------------------------|---------------------------------------------------------------------- |
| `data.archive_file.manage_ssm_password_zip`       | Archive file for managing SSM passwords.                    | deploy_prep_main, deploy_prep_dr                                      |
| `data.archive_file.remove_permissions_zip`        | Archive file for removing permissions.                      | deploy_prep_main, deploy_prep_dr                                      |
| `data.archive_file.retrieve_success_signal_zip`   | Archive file for retrieving success signal.                 | deploy_prep_main, deploy_prep_dr                                      |
| `data.aws_ami.vault_ami`                          | AWS AMI for vaults.                                         | [Vault Instances](#vault-instances)                                   |
| `data.aws_availability_zones.available`           | AWS availability zones information.                         | pam_network_main, pam_network_dr                                      |
| `data.aws_caller_identity.current`                | AWS Caller Identity of current user.                        | [Vault Instances](#vault-instances), deploy_prep_main, deploy_prep_dr |
| `data.aws_partition.current`                      | Current AWS partition.                                      | [Vault Instances](#vault-instances), deploy_prep_main, deploy_prep_dr |
| `data.aws_region.current`                         | Current AWS region.                                         | [All Modules](#all-modules)                                           |
| `null_resource.always_recreate`                   | Triggers resource recreation.                               | [All Modules](#all-modules)                                           |
| `random_string.deployment_uid`                    | Unique identifier for deployment.                           | [Vault Instances](#vault-instances),deploy_prep_main, deploy_prep_dr  |

### Each nickname includes the following modules

<a name="vault-instances"></a>
**_Vault Instances_**:  
   `vault_instance`, `vault_dr_instance`

<a name="all-modules"></a>
**_All Modules (excl. peering)_**:  
   `vault_instance`, `vault_dr_instance`, `deploy_prep_main`, `deploy_prep_dr`, `pam_network_main` ,`pam_network_dr`

<!-- END_TF_DOCS -->
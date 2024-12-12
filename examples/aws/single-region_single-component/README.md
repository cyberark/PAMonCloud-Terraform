# PAMonCloud for AWS - Single PAM Component Deployment

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
| <a name="module_deploy_prerequisites"></a> [deploy_prerequisites](#module\_deploy\_prerequisites) | ../../../modules/aws/components/deploy_prerequisites | n/a |
| <a name="module_component"></a> [component](#module\_component) | ../../../modules/aws/components/component | n/a |

## Inputs

| Name | Description |
|------|-------------|
| <a name="input_component"></a> [component](#input\_component) | The name of the PAM component. |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the EC2 key pair to use. |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet in which the EC2 instance will be launched. |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | A list of security group IDs to associate with the EC2 instance. |
| <a name="input_primary_vault_ip"></a> [primary\_vault\_ip](#input\_primary\_vault\_ip) | The IP address of the primary Vault. |
| <a name="input_vault_dr_ip"></a> [vault\_dr\_ip](#input\_vault\_dr\_ip) | The IP address of Vault DR. (Optional) |
| <a name="input_vault_admin_password"></a> [vault\_admin\_password](#input\_vault\_admin\_password) | Primary Vault Admin Password. |
| <a name="input_pvwa_private_dns"></a> [pvwa\_private\_dns](#input\_pvwa\_private\_dns) | The private DNS of the PVWA Instance. (Required only when component is PTA) |
| <a name="input_component_custom_ami_id"></a> [component\_custom\_ami\_id](#input\_component\_custom\_ami\_id) | Custom AMI ID to use instead of the default one. (Optional) |

## Outputs

| Name | Module | Description |
|------|--------|-------------|
| <a name="output_deployment_uid"></a> [deployment\_uid](#output\_deployment\_uid) | deploy_prerequisites | Deployment Unique ID. |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | deploy_prerequisites | CloudWatch Log Group name. |
| <a name="output_component_instance_ip_address"></a> [component\_instance\_ip\_address](#output\_component\_instance\_ip\_address) | component | Component instance IP address. |
| <a name="output_component_instance_private_dns"></a> [component\_instance\_private\_dns](#output\_component\_instance\_private\_dns) | component | Component instance private DNS. |
| <a name="output_component_instance_id"></a> [component\_instance\_id](#output\_component\_instance\_id) | component | Component instance ID. |
| <a name="output_component_instance_hostname"></a> [component\_instance\_hostname](#output\_component\_instance\_hostname) | component | Component instance hostname. |

## Resources

### Retrieve information about a resource (post deployment)
You can use the `terraform state show` command followed by: `module.<module_name>.<resource_name>`  
Example: `terraform state show 'module.aws_instance.component'`  
For list objects, you can use `terraform state list` to get all objects within the list.

#### **EC2 Instances**
| Resource                              | Description                                    | Module       |
|---------------------------------------|------------------------------------------------|--------------|
| `aws_instance.component`              | Component EC2 instance resource.               | component    |

#### **CloudWatch Resources**
| Resource                                                      | Description                                                | Module        |
|---------------------------------------------------------------|------------------------------------------------------------|---------------|
| `aws_cloudwatch_log_group.log_group`                          | CloudWatch log group.                                      | deploy_prep   |
| `aws_cloudwatch_log_stream.additional_log_streams` (list)     | CloudWatch log streams for additional configuration.       | component     |
| `aws_cloudwatch_log_stream.user_data_log_stream`              | CloudWatch log stream for user data logs.                  | component     |

#### **IAM Roles/Policies**
| Resource                                                                                 | Description                                                     | Module         |
|------------------------------------------------------------------------------------------|-----------------------------------------------------------------|----------------|
| `aws_iam_instance_profile.instance_profile`                                              | IAM instance profile.                                           | component      |
| `aws_iam_role.instance_role`                                                             | IAM role for the instance.                                      | component      |
| `aws_iam_role.lambda_manage_ssm_password_role`                                           | IAM role for managing SSM password in Lambda.                   | deploy_prep    |
| `aws_iam_role.lambda_remove_permissions_role`                                            | IAM role for removing permissions in Lambda.                    | deploy_prep    |
| `aws_iam_role.lambda_retrieve_success_signal_role`                                       | IAM role for retrieving success signal in Lambda.               | deploy_prep    |
| `aws_iam_role_policy.instance_cloudwatch_policy`                                         | IAM policy for CloudWatch logging.                              | component      |
| `aws_iam_role_policy.instance_kms_policy`                                                | IAM policy for AWS KMS.                                         | component      |
| `aws_iam_role_policy.instance_ssm_policy`                                                | IAM policy for SSM management.                                  | component      |
| `aws_iam_role_policy.lambda_manage_ssm_password_policy`                                  | IAM policy for managing SSM password in Lambda.                 | deploy_prep    |
| `aws_iam_role_policy.lambda_retrieve_success_signal_policy`                              | IAM policy for retrieving success signal in Lambda.             | deploy_prep    |
| `aws_iam_role_policy_attachment.instance_ssm_managed_policy`                             | IAM role policy attachment for AWS managed SSM policy.          | component      |
| `aws_iam_role_policy_attachment.lambda_manage_ssm_password_execution_managed_policy`     | IAM policy attachment for Lambda to manage SSM password.        | deploy_prep    |
| `aws_iam_role_policy_attachment.lambda_remove_permissions_execution_managed_policy`      | IAM policy attachment for Lambda to remove permissions.         | deploy_prep    |
| `aws_iam_role_policy_attachment.lambda_retrieve_success_signal_execution_managed_policy` | IAM policy attachment for Lambda to retrieve success signal.    | deploy_prep    |
| `data.aws_iam_policy_document.instance_assume_role_policy`                               | IAM policy document defining instance assume role policy.       | component      |
| `data.aws_iam_policy_document.lambda_assume_role_policy`                                 | IAM policy document for Lambda assume role.                     | deploy_prep    |

#### **Lambda Resources**
| Resource                                             | Description                                                   | Module         |
|------------------------------------------------------|---------------------------------------------------------------|----------------|
| `aws_lambda_function.manage_ssm_password_lambda`     | Lambda for managing SSM password.                             | deploy_prep    |
| `aws_lambda_function.remove_permissions_lambda`      | Lambda for removing permissions.                              | deploy_prep    |
| `aws_lambda_function.retrieve_success_signal_lambda` | Lambda for retrieving success signal.                         | deploy_prep    |
| `aws_lambda_invocation.remove_admin_password`	       | Lambda invocation for removing admin password.	               | component      |
| `aws_lambda_invocation.store_admin_password`	       | Lambda invocation for storing admin password.	               | component      |
| `aws_lambda_invocation.wait_for_userdata_completion` | Lambda invocation to monitor user data completion.            | component      |

#### **Miscellaneous**
| Resource                                          | Description                                                 | Module                  |
|---------------------------------------------------|-------------------------------------------------------------|-------------------------|
| `data.archive_file.manage_ssm_password_zip`       | Archive file for managing SSM passwords.                    | deploy_prep             |
| `data.archive_file.remove_permissions_zip`        | Archive file for removing permissions.                      | deploy_prep             |
| `data.archive_file.retrieve_success_signal_zip`   | Archive file for retrieving success signal.                 | deploy_prep             |
| `data.aws_ami.component_ami`                      | AWS AMI for components.                                     | component               |
| `data.aws_caller_identity.current`                | AWS Caller Identity of current user.                        | component, deploy_prep  |
| `data.aws_partition.current`                      | Current AWS partition.                                      | component, deploy_prep  |
| `data.aws_region.current`                         | Current AWS region.                                         | component, deploy_prep  |
| `null_resource.always_recreate`                   | Triggers resource recreation.                               | component, deploy_prep  |
| `null_resource.userdata_updated`                  | Manages updates to user data.                               | component               |
| `random_string.deployment_uid`                    | Unique identifier for deployment.                           | component, deploy_prep  |

<!-- END_TF_DOCS -->

# PAMonCloud for AWS - Component Terraform Module

This module deploys and manages PAM components like **PVWA**, **CPM**, **PSM**, **PSMP**, and **PTA** as EC2 instances in AWS. It supports custom instance configurations and integrates with networking, logging, and AWS Lambda for enhanced functionality.

## Usage

See [`examples`](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/aws) directory for working examples to reference:

The following example demonstrates how to use the `component` module to deploy a **PVWA** instance. This example can be adapted for other components (such as **CPM**, **PSM**, **PSMP**, and **PTA**) by changing the `component` value to the respective component name.

```hcl
module "pvwa_instance" {
  source                         = "../../../modules/aws/components/component"
  instance_name                  = "pvwa-instance"
  instance_type                  = "m5.xlarge"
  key_name                       = "my-key"
  subnet_id                      = "subnet-0bb1c79de3EXAMPLE"
  vpc_security_group_ids         = ["sg-04e1a1d2f5dEXAMPLE"]
  custom_ami_id                  = "ami-0c55b159cbEXAMPLE"
  primary_vault_ip               = "10.0.1.1"
  vault_dr_ip                    = "10.0.1.2"
  instance_hostname              = "pvwa"
  component                      = "PVWA" // Valid option : PVWA, CPM, PSM, PSMP, PTA
  vault_admin_username           = "Administrator"
  vault_admin_password           = "VaultPassword"
  log_group_name                 = "group_name"
  manage_ssm_password_lambda = {
  function_name = "ManageSSMPasswordLambda" // Example Lambda function name
  }
  retrieve_success_signal_lambda = {
    function_name = "RetrieveSuccessSignalLambda"
  }
}
```

## Examples

- [single-region_complete-pam](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/aws/single-region_complete-pam) with Component.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.73.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.2 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.73.0 |

## Modules

No modules.

## Resources

### Retrieve information about a resource (post deployment)
You can use the `terraform state show` command followed by: `module.<module_name>.<resource_name>`  
Example: `terraform state show 'module.pvwa_instance.aws_instance.component'`  
For list objects, you can use `terraform state list` to get all objects within the list.

| Name                                                          | Description                                               |
|---------------------------------------------------------------|-----------------------------------------------------------|
| `aws_instance.component`                                      | Component EC2 instance resource.                          |
| `aws_cloudwatch_log_stream.additional_log_streams` (list)     | CloudWatch log streams for additional configuration.      |
| `aws_cloudwatch_log_stream.user_data_log_stream`              | CloudWatch log stream for user data logs.                 |
| `aws_iam_instance_profile.instance_profile`                   | IAM instance profile.                                     |
| `aws_iam_role.instance_role`                                  | IAM role for the instance.                                |
| `aws_iam_role_policy.instance_cloudwatch_policy`              | IAM policy for CloudWatch logging.                        |
| `aws_iam_role_policy.instance_kms_policy`                     | IAM policy for AWS KMS.                                   |
| `aws_iam_role_policy.instance_ssm_policy`                     | IAM policy for SSM management.                            |
| `aws_iam_role_policy_attachment.instance_ssm_managed_policy`  | IAM role policy attachment for AWS managed SSM policy.    |
| `data.aws_iam_policy_document.instance_assume_role_policy`    | IAM policy document defining instance assume role policy. |
| `aws_lambda_invocation.remove_admin_password`	                | Lambda invocation for removing admin password.	          |
| `aws_lambda_invocation.store_admin_password`	                | Lambda invocation for storing admin password.	            |
| `aws_lambda_invocation.wait_for_userdata_completion`          | Lambda invocation to monitor user data completion.        |
| `data.aws_ami.component_ami`                                  | AWS AMI for components.                                   | 
| `data.aws_caller_identity.current`                            | AWS Caller Identity of current user.                      |
| `data.aws_partition.current`                                  | Current AWS partition.                                    |
| `data.aws_region.current`                                     | Current AWS region.                                       |
| `null_resource.always_recreate`                               | Triggers resource recreation.                             |
| `null_resource.userdata_updated`                              | Manages updates to user data.                             | 
| `random_string.deployment_uid`                                | Unique identifier for deployment.                         |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name)| The name of the EC2 instance | `string` | `null` | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type)| The type of the EC2 instance. Allowed types are: c5.xlarge, m5.xlarge, c5.2xlarge, m5.2xlarge, c5.4xlarge, m5.4xlarge, c5.9xlarge, m5.8xlarge. | `string` | `null`| yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the EC2 key pair to use. Must be between 1 and 255 characters long and can only contain alphanumeric characters, hyphens (-), and underscores (_)." | `string` | `null` | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id)| The ID of the subnet in which the EC2 instance will be launched. | `string` | `null` | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | list of security group IDs to associate with the EC2 instance.| `list(string)` | `null` | yes |
| <a name="input_custom_ami_id"></a> [custom\_ami\_id](#input\_custom\_ami\_id)| Custom AMI ID to use instead of the default one. (Optional) | `string` | `null` | no |
| <a name="input_primary_vault_ip"></a> [primary\_vault\_ip](#input\_primary\_vault\_ip) | The IP address of the primary Vault.| `string` | `null` | yes |
| <a name="input_vault_dr_ip"></a> [vault\_dr\_ip](#input\_vault\_dr\_ip) | The IP address of Vault DR. | `string` | `null`  | yes |
| <a name="input_instance_hostname"></a> [instance\_hostname](#input\_instance\_hostname) | The hostname for the EC2 instance. Must be 3 to 15 characters long, contain at least one letter, and must not start or end with a hyphen. | `string` | `null` | yes |
| <a name="input_component"></a> [component](#input\_component) | The name of the PAM component. Supported values: `PVWA`, `CPM`, `PSM`, `PSMP`, `PTA`. | `string` | `null` | yes |
| <a name="input_vault_admin_username"></a> [vault\_admin\_username](#input\_vault\_admin\_username) | The username of the Vault administrator. | `string` | `"Administrator"`| no |
| <a name="input_vault_admin_password"></a> [vault\_admin\_password](#input\_vault\_admin\_password) | The password of the Vault administrator. | `string` | `null`| yes |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name)| The name of the CloudWatch log group. | `string` | `null` | yes|
| <a name="input_manage_ssm_password_lambda"></a> [manage\_ssm\_password\_lambda](#input\_manage\_ssm\_password\_lambda) | Required specs for the Lambda function that manages SSM passwords. | `object({function_name = string})` | `null` | yes|
| <a name="input_retrieve_success_signal_lambda"></a> [retrieve\_success\_signal\_lambda](#input\_retrieve\_success\_signal\_lambda) | Required specs for the Lambda function that retrieves success signals. | `object({function_name = string})` | `null` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deployment_uid"></a> [deployment\_uid](#output\_deployment\_uid)| The unique deployment identifier. |
| <a name="output_instance_ip_address"></a> [instance\_ip\_address](#output\_instance\_ip\_address) | The private IP address of the instance.|
| <a name="output_instance_private_dns"></a> [instance\_private\_dns](#output\_instance\_private\_dns) | The private DNS name of the instance. |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The unique instance ID. |
| <a name="output_instance_hostname"></a> [instance\_hostname](#output\_instance\_hostname) | The hostname of the instance. |

<!-- END_TF_DOCS -->
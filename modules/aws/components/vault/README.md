# PAMonCloud for AWS - Vault Terraform Module

This module is used to deploy and manage a **Vault** instance within an AWS environment. It provisions an EC2 instance for Vault, integrates with networking, and handles configuration related to Vault's license, recovery keys, and additional Lambda functions.

## Usage

See [`examples`](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/aws) directory for working examples to reference:

```hcl
module "vault_instance" {
  source                         = "../../../modules/aws/components/vault"
  instance_name                  = "PrimaryVault"
  instance_type                  = "m5.xlarge"
  key_name                       = "vault-key"
  subnet_id                      = "subnet-0bb1c79de3EXAMPLE"
  vpc_security_group_ids         = ["sg-04e1a1d2f5dEXAMPLE"]
  custom_ami_id                  = "ami-0c55b159chEXAMPLE"
  vault_files_bucket             = "vault-files-bucket"
  license_file                   = "license.xml"
  recovery_public_key_file       = "recpub.key"
  instance_hostname              = "vault"
  vault_master_password          = "VaultMasterPassword"
  vault_admin_password           = "VaultAdminPassword"
  vault_dr_password              = "VaultDrPassword"
  vault_dr_secret                = "VaultDrSecret"
  log_group_name                 = "vault-log-group"
  manage_ssm_password_lambda     = {
    function_name = "manage_ssm_password_lambda_function"
  }
  retrieve_success_signal_lambda = {
    function_name = "retrieve_success_signal_lambda_function"
  }
  remove_permissions_lambda = {
    function_name = "RemovePermissionsLambda",
    arn           = "arn:aws:lambda:us-east-1:123456789012:function:RemovePermissionsLambda",
    role_name     = "lambda_remove_permissions_role"
  }
}
```

## Examples

- [single-region_complete-pam](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/aws/single-region_complete-pam) with Vault.

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
Example: `terraform state show 'module.vault_instance.aws_instance.vault'`  
For list objects, you can use `terraform state list` to get all objects within the list.

| Name                                                            | Description                                                |
|-----------------------------------------------------------------|------------------------------------------------------------|
| `aws_instance.vault`                                            | Primary Vault EC2 instance resource.                       |
| `aws_cloudwatch_log_stream.additional_log_streams` (list)       | CloudWatch log streams for additional configuration.       |
| `aws_cloudwatch_log_stream.user_data_log_stream`                | CloudWatch log stream for user data logs.                  |
| `aws_iam_instance_profile.instance_profile`                     | IAM instance profile.                                      |
| `aws_iam_role.instance_role`                                    | IAM role for the instance.                                 |
| `aws_iam_role_policy.instance_cloudwatch_policy`                | IAM policy for CloudWatch logging.                         |
| `aws_iam_role_policy.instance_kms_policy`                       | IAM policy for AWS KMS.                                    |
| `aws_iam_role_policy.instance_s3_policy`                        | IAM policy for S3 access.                                  |
| `aws_iam_role_policy.instance_ssm_policy`                       | IAM policy for SSM management.                             |
| `aws_iam_role_policy.lambda_remove_permissions_policy`          | IAM policy for removing permissions via Lambda.            |
| `aws_iam_role_policy_attachment.instance_ssm_managed_policy`    | IAM role policy attachment for AWS managed SSM policy.     |
| `data.aws_iam_policy_document.instance_assume_role_policy`      | IAM policy document defining instance assume role policy.  |
| `data.aws_iam_policy_document.lambda_remove_permissions_policy` | IAM policy document for removing permissions via Lambda.   |
| `aws_lambda_invocation.remove_admin_password`	                  | Lambda invocation for removing admin password.	           | 
| `aws_lambda_invocation.remove_dr_password`                      | Lambda invocation for removing DR password.                | 
| `aws_lambda_invocation.remove_dr_secret[0]`                     | Lambda invocation for removing DR secret.                  | 
| `aws_lambda_invocation.remove_master_password`                  | Lambda invocation for removing master password.            | 
| `aws_lambda_invocation.remove_permissions`                      | Lambda invocation for removing deployment temp permissions.| 
| `aws_lambda_invocation.store_admin_password`	                  | Lambda invocation for storing admin password.	             |
| `aws_lambda_invocation.store_dr_password`                       | Lambda invocation for storing DR password.                 | 
| `aws_lambda_invocation.store_dr_secret[0]`                      | Lambda invocation for storing DR secret.                   | 
| `aws_lambda_invocation.store_master_password`                   | Lambda invocation for storing master password.             | 
| `aws_lambda_invocation.wait_for_userdata_completion`            | Lambda invocation to monitor user data completion.         |
| `data.aws_ami.vault_ami`                                        | AWS AMI for vaults.                                        |
| `data.aws_region.current`                                       | Current AWS region.                                        |
| `null_resource.always_recreate`                                 | Triggers resource recreation.                              |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_name"></a> [instance\_name](#input_instance\_name) | The name of the EC2 instance. | `string` | `null` | yes |
| <a name="input_instance_hostname"></a> [instance\_hostname](#input_instance\_hostname) | The hostname for the EC2 instance. | `string` | `null` | yes |
| <a name="input_instance_type"></a> [instance\_type](#input_instance\_type) | The type of the EC2 instance. Allowed types are: c5.xlarge, m5.xlarge, c5.2xlarge, m5.2xlarge, c5.4xlarge, m5.4xlarge, c5.9xlarge, m5.8xlarge. | `string` | `null` | yes |
| <a name="input_key_name"></a> [key\_name](#input_key\_name) | The name of the EC2 key pair to use. Must be between 1 and 255 characters long and can only contain alphanumeric characters, hyphens (-), and underscores (_). | `string` | `null` | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input_subnet\_id) | The ID of the subnet in which the EC2 instance will be launched. | `string` | `null` | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input_vpc\_security\_group\_ids) | A list of security group IDs to associate with the EC2 instance. | `list(string)` | `null` | yes |
| <a name="input_vault_master_password"></a> [vault\_master\_password](#input_vault\_master\_password) | Primary Vault Master Password. | `string` | `null` | yes |
| <a name="input_vault_admin_password"></a> [vault\_admin\_password](#input_vault\_admin\_password) | Primary Vault Admin Password. | `string` | `null` | yes |
| <a name="input_vault_dr_password"></a> [vault\_dr\_password](#input_vault\_dr\_password) | Vault DR User Password. | `string` | `null` | yes |
| <a name="input_vault_dr_secret"></a> [vault\_dr\_secret](#input_vault\_dr\_secret) | Vault DR User Secret. (Required only for DR implementations) | `string` | `null` | no |
| <a name="input_vault_files_bucket"></a> [vault\_files\_bucket](#input_vault\_files\_bucket) | The name of the S3 bucket where Vault license and recovery key are stored. | `string` | `null` | yes |
| <a name="input_license_file"></a> [license\_file](#input_license\_file) | The name of the license file stored in the S3 bucket. | `string` | `license.xml` | no |
| <a name="input_recovery_public_key_file"></a> [recovery\_public\_key\_file](#input_recovery\_public\_key\_file) | The name of the recovery public key file stored in the S3 bucket. | `string` | `recpub.key` | no |
| <a name="input_custom_ami_id"></a> [custom\_ami\_id](#input_custom\_ami\_id) | Custom AMI ID to use instead of the default one. (Optional) | `string` | `null` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input_log\_group\_name) | The name of the CloudWatch log group. | `string` | `null` | yes |
| <a name="input_manage_ssm_password_lambda"></a> [manage\_ssm\_password\_lambda](#input_manage\_ssm\_password\_lambda) | Required specs for the Lambda function that manages SSM passwords. | `object({ function_name = string })` | `null` | yes |
| <a name="input_retrieve_success_signal_lambda"></a> [retrieve\_success\_signal\_lambda](#input_retrieve\_success\_signal\_lambda) | Required specs for the Lambda function that retrieves success signals. | `object({ function_name = string })` | `null` | yes |
| <a name="input_remove_permissions_lambda"></a> [remove\_permissions\_lambda](#input_remove\_permissions\_lambda) | Required specs for the Lambda function that removes permissions. | `object({ function_name = string, arn = string, role_name = string })` | `null` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deployment_uid"></a> [deployment\_uid](#output\_deployment\_uid) | The unique deployment identifier. |
| <a name="output_instance_ip_address"></a> [instance\_ip\_address](#output\_instance\_ip\_address) | The private IP address of the instance. |
| <a name="output_instance_private_dns"></a> [instance\_private\_dns](#output\_instance\_private\_dns) | The private DNS name of the instance. |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The unique instance ID. |
| <a name="output_instance_hostname"></a> [instance\_hostname](#output\_instance\_hostname) | The hostname of the EC2 instance. |

<!-- END_TF_DOCS -->
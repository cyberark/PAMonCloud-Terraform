# PAMonCloud for AWS - Vault DR Terraform Module

This module deploys and manages the Vault Disaster Recovery (Vault DR) component as an EC2 instance within an AWS environment. It is designed to replicate the primary Vault instance and provides high availability for the Vault service.

## Usage

See [`examples`](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/aws) directory for working examples to reference:

```hcl
module "vault_dr_instance" {
  source                         = "../../../modules/aws/components/vault_dr"
  instance_name                  = "vault-dr-instance"
  instance_type                  = "m5.xlarge"
  key_name                       = "vault-key" 
  subnet_id                      = "subnet-0bb1c79de3EXAMPLE"
  vpc_security_group_ids         = ["sg-0bb1c79de3EXAMPLE"]
  custom_ami_id                  = "ami-0a9c30a2EXAMPLE"
  primary_vault_ip               = "10.0.0.1"
  instance_hostname              = "vault-dr"
  vault_dr_password              = "vault_dr_password"
  vault_dr_secret                = "vault_dr_secret"
  log_group_name                 = "vault-dr-logs"
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
  depends_on                     = [module.vault_instance]  // Ensure Vault instance is created first
}
```

## Examples

- [single-region_complete-pam](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/aws/single-region_complete-pam) with Vault DR.

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
Example: `terraform state show 'module.vault_dr_instance.aws_instance.vault_dr'`  
For list objects, you can use `terraform state list` to get all objects within the list.

| Name                                                            | Description                                                |
|-----------------------------------------------------------------|------------------------------------------------------------|
| `aws_instance.vault_dr`                                         | DR Vault EC2 instance resource.                            | 
| `aws_cloudwatch_log_stream.additional_log_streams` (list)       | CloudWatch log streams for additional configuration.       |
| `aws_cloudwatch_log_stream.user_data_log_stream`                | CloudWatch log stream for user data logs.                  |
| `aws_iam_instance_profile.instance_profile`                     | IAM instance profile.                                      |
| `aws_iam_role.instance_role`                                    | IAM role for the instance.                                 |
| `aws_iam_role_policy.instance_cloudwatch_policy`                | IAM policy for CloudWatch logging.                         |
| `aws_iam_role_policy.instance_kms_policy`                       | IAM policy for AWS KMS.                                    |
| `aws_iam_role_policy.instance_ssm_policy`                       | IAM policy for SSM management.                             |
| `aws_iam_role_policy.lambda_remove_permissions_policy`          | IAM policy for removing permissions via Lambda.            |
| `aws_iam_role_policy_attachment.instance_ssm_managed_policy`    | IAM role policy attachment for AWS managed SSM policy.     |
| `data.aws_iam_policy_document.instance_assume_role_policy`      | IAM policy document defining instance assume role policy.  |
| `data.aws_iam_policy_document.lambda_remove_permissions_policy` | IAM policy document for removing permissions via Lambda.   |
| `aws_lambda_invocation.remove_dr_password`                      | Lambda invocation for removing DR password.                | 
| `aws_lambda_invocation.remove_dr_secret[0]`                     | Lambda invocation for removing DR secret.                  | 
| `aws_lambda_invocation.remove_master_password`                  | Lambda invocation for removing master password.            | 
| `aws_lambda_invocation.remove_permissions`                      | Lambda invocation for removing deployment temp permissions.| 
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
| <a name="input_custom_ami_id"></a> [custom\_ami\_id](#input_custom\_ami\_id) | Custom AMI ID to use instead of the default one. (Optional) | `string` | `null` | no |
| <a name="input_primary_vault_ip"></a> [primary\_vault\_ip](#input_primary\_vault\_ip) | "The IP address of the primary Vault. | `string` | `null` | yes |
| <a name="input_vault_dr_password"></a> [vault\_dr\_password](#input_vault\_dr\_password) | Vault DR User Password. | `string` | `null` | yes |
| <a name="input_vault_dr_secret "></a> [vault\_dr\_secret](#input_vault\_dr\_secret) | Vault DR User Secret | `string` | `null` | yes |
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
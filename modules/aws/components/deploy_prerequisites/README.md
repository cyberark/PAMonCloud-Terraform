# PAMonCloud for AWS - Deploy Prerequisites Terraform Module

This module is used to set up essential AWS resources required for the deployment of CyberArk components, such as CloudWatch log groups, Lambda functions, and IAM roles. The Deploy Prerequisites module does not require any input variables and manages the deployment of Lambda functions and the IAM roles necessary for the overall CyberArk infrastructure deployment.

## Usage

See [`examples`](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/aws) directory for working examples to reference:

```hcl
module "deploy_prep" {
  source = "../../../modules/aws/components/deploy_prerequisites"
}
```

## Examples

- [single-region_complete-pam](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/aws/single-region_complete-pam) with Deploy Prerequisites.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.73.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.2 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.3 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | 2.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.73.0 |

## Modules

No modules.

## Resources

### Retrieve information about a resource (post deployment)
You can use the `terraform state show` command followed by: `module.<module_name>.<resource_name>`  
Example: `terraform state show 'module.deploy_prep.aws_cloudwatch_log_group.log_group'`  
For list objects, you can use `terraform state list` to get all objects within the list.

| Name                                                                                     | Description                                                 |
|------------------------------------------------------------------------------------------|-------------------------------------------------------------|
| `aws_cloudwatch_log_group.log_group`                                                     | CloudWatch log group.                                       |
| `aws_iam_role.lambda_manage_ssm_password_role`                                           | IAM role for managing SSM password in Lambda.               |
| `aws_iam_role.lambda_remove_permissions_role`                                            | IAM role for removing permissions in Lambda.                |
| `aws_iam_role.lambda_retrieve_success_signal_role`                                       | IAM role for retrieving success signal in Lambda.           |
| `aws_iam_role_policy.lambda_manage_ssm_password_policy`                                  | IAM policy for managing SSM password in Lambda.             |
| `aws_iam_role_policy.lambda_retrieve_success_signal_policy`                              | IAM policy for retrieving success signal in Lambda.         |
| `aws_iam_role_policy_attachment.lambda_manage_ssm_password_execution_managed_policy`     | IAM policy attachment for Lambda to manage SSM password.    |
| `aws_iam_role_policy_attachment.lambda_remove_permissions_execution_managed_policy`      | IAM policy attachment for Lambda to remove permissions.     |
| `aws_iam_role_policy_attachment.lambda_retrieve_success_signal_execution_managed_policy` | IAM policy attachment for Lambda to retrieve success signal.|
| `data.aws_iam_policy_document.lambda_assume_role_policy`                                 | IAM policy document for Lambda assume role.                 |
|  `aws_lambda_function.manage_ssm_password_lambda`                                        | Lambda for managing SSM password.                           |
| `aws_lambda_function.remove_permissions_lambda`                                          | Lambda for removing permissions.                            |
| `aws_lambda_function.retrieve_success_signal_lambda`                                     | Lambda for retrieving success signal.                       |
| `data.archive_file.manage_ssm_password_zip`                                              | Archive file for managing SSM passwords.                    |
| `data.archive_file.remove_permissions_zip`                                               | Archive file for removing permissions.                      |
| `data.archive_file.retrieve_success_signal_zip`                                          | Archive file for retrieving success signal.                 |
| `data.aws_caller_identity.current`                                                       | AWS Caller Identity of current user.                        |
| `data.aws_partition.current`                                                             | Current AWS partition.                                      |
| `data.aws_region.current`                                                                | Current AWS region.                                         |
| `null_resource.always_recreate`                                                          | Triggers resource recreation.                               |
| `random_string.deployment_uid`                                                           | Unique identifier for deployment.                           |

## Inputs

No Inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deployment_uid"></a> [deployment\_uid](#output\_deployment\_uid) | The unique deployment identifier. |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | The name of the CloudWatch log group. |
| <a name="output_manage_ssm_password_lambda"></a> [manage\_ssm\_password\_lambda](#output_manage\_ssm\_password\_lambda) | The Lambda function name that manages SSM passwords. |
| <a name="output_retrieve_success_signal_lambda"></a> [retrieve\_success\_signal\_lambda](#output_retrieve\_success\_signal\_lambda) | The Lambda function name that retrieves success signals. |
| <a name="output_remove_permissions_lambda"></a> [remove\_permissions\_lambda](#output_remove\_permissions\_lambda) | The Lambda function details for removing permissions, including function name, ARN, and role name. |

<!-- END_TF_DOCS -->
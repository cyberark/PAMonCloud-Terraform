output "deployment_uid" {
  value = random_string.deployment_uid.result
}

output "log_group_name" {
  value = local.log_group_name
}

output "manage_ssm_password_lambda" {
  value = {
    function_name = aws_lambda_function.manage_ssm_password_lambda.function_name
  }
}

output "retrieve_success_signal_lambda" {
  value = {
    function_name = aws_lambda_function.retrieve_success_signal_lambda.function_name
  }
}

output "remove_permissions_lambda" {
  value = {
    function_name = aws_lambda_function.remove_permissions_lambda.function_name
    arn           = aws_lambda_function.remove_permissions_lambda.arn
    role_name     = aws_iam_role.lambda_remove_permissions_role.name
  }
}
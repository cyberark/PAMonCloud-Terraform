#### Pack Lambda Functions

data "archive_file" "manage_ssm_password_zip" {
  type        = "zip"
  source_file = "${path.module}/scripts/manage_ssm_password.py"
  output_path = "${path.module}/scripts/lambdas/manage_ssm_password.zip"
}

data "archive_file" "retrieve_success_signal_zip" {
  type        = "zip"
  source_file = "${path.module}/scripts/retrieve_success_signal.py"
  output_path = "${path.module}/scripts/lambdas/retrieve_success_signal.zip"
}

data "archive_file" "remove_permissions_zip" {
  type        = "zip"
  source_file = "${path.module}/scripts/remove_permissions.py"
  output_path = "${path.module}/scripts/lambdas/remove_permissions.zip"
}

#### Lambda Functions

resource "aws_lambda_function" "manage_ssm_password_lambda" {
  filename         = "${path.module}/scripts/lambdas/manage_ssm_password.zip"
  source_code_hash = data.archive_file.manage_ssm_password_zip.output_base64sha256
  function_name    = "PAMonCloud_TF_ManageSSMPassword_Lambda_${random_string.deployment_uid.result}"
  description      = "Store and clean passwords in SSM Parameter Store"
  role             = aws_iam_role.lambda_manage_ssm_password_role.arn
  handler          = "manage_ssm_password.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60
}

resource "aws_lambda_function" "retrieve_success_signal_lambda" {
  filename         = "${path.module}/scripts/lambdas/retrieve_success_signal.zip"
  source_code_hash = data.archive_file.retrieve_success_signal_zip.output_base64sha256
  function_name    = "PAMonCloud_TF_RetrieveSuccessSignal_Lambda_${random_string.deployment_uid.result}"
  description      = "Confirm script completion using CloudWatch Logs"
  role             = aws_iam_role.lambda_retrieve_success_signal_role.arn
  handler          = "retrieve_success_signal.lambda_handler"
  runtime          = "python3.9"
  timeout          = 900
}

resource "aws_lambda_function" "remove_permissions_lambda" {
  filename         = "${path.module}/scripts/lambdas/remove_permissions.zip"
  source_code_hash = data.archive_file.remove_permissions_zip.output_base64sha256
  function_name    = "PAMonCloud_TF_RemovePermissions_Lambda_${random_string.deployment_uid.result}"
  description      = "Remove temporary permissions from Vault instance IAM role post deployment"
  role             = aws_iam_role.lambda_remove_permissions_role.arn
  handler          = "remove_permissions.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60
}
#### Store passwords in SSM

resource "aws_lambda_invocation" "store_admin_password" {
  function_name = var.manage_ssm_password_lambda.function_name
  input = jsonencode({
    ResourceProperties = {
      Action   = "Create"
      Password = var.vault_admin_password
    }
  })
  lifecycle {
    replace_triggered_by = [null_resource.always_recreate]
  }
}

#### Wait for Component UserData completion

resource "aws_lambda_invocation" "wait_for_userdata_completion" {
  function_name = var.retrieve_success_signal_lambda.function_name
  input = jsonencode({
    log_group_name  = var.log_group_name
    log_stream_name = aws_cloudwatch_log_stream.user_data_log_stream.name
    success_signal  = local.success_signal
    region          = local.region
  })
  depends_on = [aws_instance.component]
  lifecycle {
    replace_triggered_by = [aws_instance.component.id]
  }
}

#### Remove passwords in SSM

resource "aws_lambda_invocation" "remove_admin_password" {
  function_name = var.manage_ssm_password_lambda.function_name
  input = jsonencode({
    ResourceProperties = {
      Action = "Delete"
      SsmId  = local.admin_password_ssm_id
    }
  })
  depends_on = [aws_lambda_invocation.wait_for_userdata_completion]
}
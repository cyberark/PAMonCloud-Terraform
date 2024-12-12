#### Store passwords in SSM

resource "aws_lambda_invocation" "store_master_password" {
  function_name = var.manage_ssm_password_lambda.function_name
  input = jsonencode({
    ResourceProperties = {
      Action   = "Create"
      Password = var.vault_master_password
    }
  })
  lifecycle {
    replace_triggered_by = [null_resource.always_recreate]
  }
}

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

resource "aws_lambda_invocation" "store_dr_password" {
  function_name = var.manage_ssm_password_lambda.function_name
  input = jsonencode({
    ResourceProperties = {
      Action   = "Create"
      Password = var.vault_dr_password
    }
  })
  lifecycle {
    replace_triggered_by = [null_resource.always_recreate]
  }
}

resource "aws_lambda_invocation" "store_dr_secret" {
  count         = local.secret_provided ? 1 : 0
  function_name = var.manage_ssm_password_lambda.function_name
  input = jsonencode({
    ResourceProperties = {
      Action   = "Create"
      Password = var.vault_dr_secret
    }
  })
  lifecycle {
    replace_triggered_by = [null_resource.always_recreate]
  }
}

#### Wait for Vault UserData completion

resource "aws_lambda_invocation" "wait_for_userdata_completion" {
  function_name = var.retrieve_success_signal_lambda.function_name
  input = jsonencode({
    log_group_name  = var.log_group_name
    log_stream_name = aws_cloudwatch_log_stream.user_data_log_stream.name
    success_signal  = local.success_signal
    region          = local.region
  })
  depends_on = [aws_instance.vault]
  lifecycle {
    replace_triggered_by = [aws_instance.vault.id]
  }
}

#### Remove passwords in SSM

resource "aws_lambda_invocation" "remove_master_password" {
  function_name = var.manage_ssm_password_lambda.function_name
  input = jsonencode({
    ResourceProperties = {
      Action = "Delete"
      SsmId  = local.master_password_ssm_id
    }
  })
  depends_on = [aws_lambda_invocation.wait_for_userdata_completion]
}

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

resource "aws_lambda_invocation" "remove_dr_password" {
  function_name = var.manage_ssm_password_lambda.function_name
  input = jsonencode({
    ResourceProperties = {
      Action = "Delete"
      SsmId  = local.dr_password_ssm_id
    }
  })
  depends_on = [aws_lambda_invocation.wait_for_userdata_completion]
}

resource "aws_lambda_invocation" "remove_dr_secret" {
  count         = local.secret_provided ? 1 : 0
  function_name = var.manage_ssm_password_lambda.function_name
  input = jsonencode({
    ResourceProperties = {
      Action = "Delete"
      SsmId  = local.dr_secret_ssm_id
    }
  })
  depends_on = [aws_lambda_invocation.wait_for_userdata_completion]
}

#### Remove temporary deployment permissions

resource "aws_lambda_invocation" "remove_permissions" {
  function_name = var.remove_permissions_lambda.function_name
  input = jsonencode({
    ResourceProperties = {
      VaultRoleName  = aws_iam_role.instance_role.id
      LambdaRoleName = var.remove_permissions_lambda.role_name
      Instance       = aws_instance.vault.id
      Region         = local.region
    }
  })
  depends_on = [aws_lambda_invocation.wait_for_userdata_completion]
}
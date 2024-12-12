data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  account_id             = data.aws_caller_identity.current.account_id
  region                 = data.aws_region.current.name
  partition              = data.aws_partition.current.partition
  component              = "Vault"
  secret_provided        = var.vault_dr_secret != ""
  master_password_ssm_id = jsondecode(jsondecode(aws_lambda_invocation.store_master_password.result).body).response.SsmId
  admin_password_ssm_id  = jsondecode(jsondecode(aws_lambda_invocation.store_admin_password.result).body).response.SsmId
  dr_password_ssm_id     = jsondecode(jsondecode(aws_lambda_invocation.store_dr_password.result).body).response.SsmId
  dr_secret_ssm_id       = local.secret_provided ? jsondecode(jsondecode(aws_lambda_invocation.store_dr_secret[0].result).body).response.SsmId : ""
  user_data_log_stream   = "${local.component}/UserDataLog"
  success_signal         = local.component_data[local.component].success_signal
  log_streams            = local.component_data[local.component].log_streams
  user_data              = local.component_data[local.component].user_data
  default_ami_os         = "Win2019"
  ami_id                 = var.custom_ami_id != "" ? var.custom_ami_id : data.aws_ami.vault_ami.id
}

resource "null_resource" "always_recreate" {
  triggers = {
    # dummy trigger to force recreation of assigned resources
    timestamp = timestamp()
  }
}

resource "random_string" "deployment_uid" {
  length  = 12
  upper   = false
  special = false
}
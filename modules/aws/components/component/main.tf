data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  account_id            = data.aws_caller_identity.current.account_id
  region                = data.aws_region.current.name
  partition             = data.aws_partition.current.partition
  admin_password_ssm_id = jsondecode(jsondecode(aws_lambda_invocation.store_admin_password.result).body).response.SsmId
  vault_ips             = var.vault_dr_ip == "" ? var.primary_vault_ip : "${var.primary_vault_ip},${var.vault_dr_ip}"
  user_data_log_stream  = "${var.component}/UserDataLog"
  success_signal        = local.component_data[var.component].success_signal
  log_streams           = local.component_data[var.component].log_streams
  user_data             = local.component_data[var.component].user_data
  default_ami_os        = contains(["PSMP", "PTA"], var.component) ? "RHEL-9" : "Win2019"
  ami_id                = var.custom_ami_id != "" ? var.custom_ami_id : data.aws_ami.component_ami.id
}

resource "null_resource" "always_recreate" {
  triggers = {
    # dummy trigger to force recreation of assigned resources
    timestamp = timestamp()
  }
}

resource "null_resource" "userdata_updated" {
  triggers = {
    # force recreation of assigned resources when user_data changes
    user_data = local.user_data
  }
}

resource "random_string" "deployment_uid" {
  length  = 12
  upper   = false
  special = false
}
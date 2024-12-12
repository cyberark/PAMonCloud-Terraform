data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  account_id     = data.aws_caller_identity.current.account_id
  region         = data.aws_region.current.name
  partition      = data.aws_partition.current.partition
  log_group_name = "PAMonCloud_TF_Deployment_LogGroup_${random_string.deployment_uid.result}"
}

resource "random_string" "deployment_uid" {
  length  = 12
  upper   = false
  special = false
}
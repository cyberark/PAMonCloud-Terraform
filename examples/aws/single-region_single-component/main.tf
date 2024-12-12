locals {
  # General locals
  region               = "eu-west-1"
  vault_admin_username = "Administrator"

  # Component locals
  component_instance_name     = "[PAMonCloud_TF] ${var.component}"
  component_instance_type     = "m5.xlarge"
  component_instance_hostname = lower(var.component)
}

provider "aws" {
  region = local.region
}

################################################################################
# deploy_prerequisites Module
################################################################################
module "deploy_prep" {
  source = "../../../modules/aws/components/deploy_prerequisites"
}

################################################################################
# component Module
################################################################################
module "component_instance" {
  source                         = "../../../modules/aws/components/component"
  instance_name                  = local.component_instance_name
  instance_type                  = local.component_instance_type
  key_name                       = var.key_name
  subnet_id                      = var.subnet_id
  vpc_security_group_ids         = var.vpc_security_group_ids
  custom_ami_id                  = var.component_custom_ami_id
  primary_vault_ip               = var.primary_vault_ip
  vault_dr_ip                    = var.vault_dr_ip
  pvwa_private_dns               = var.pvwa_private_dns
  instance_hostname              = local.component_instance_hostname
  component                      = var.component
  vault_admin_username           = local.vault_admin_username
  vault_admin_password           = var.vault_admin_password
  log_group_name                 = module.deploy_prep.log_group_name
  manage_ssm_password_lambda     = module.deploy_prep.manage_ssm_password_lambda
  retrieve_success_signal_lambda = module.deploy_prep.retrieve_success_signal_lambda
}
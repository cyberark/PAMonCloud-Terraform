locals {
  # Network locals
  region                     = "eu-west-1"
  pam_vpc_cidr               = "10.0.0.0/16"
  network_type               = "nat"
  users_access_cidr          = "192.168.0.0/16"
  administrative_access_cidr = "192.168.1.0/24"

  # General locals
  vault_admin_username = "Administrator"

  # Primary Vault locals
  vault_instance_name            = "[PAMonCloud_TF] Primary Vault"
  vault_instance_type            = "m5.xlarge"
  vault_license_file             = "license.xml"
  vault_recovery_public_key_file = "recpub.key"
  vault_instance_hostname        = "vault"

  # Vault DR locals
  vaultdr_instance_name     = "[PAMonCloud_TF] Vault DR"
  vaultdr_instance_type     = "m5.xlarge"
  vaultdr_instance_hostname = "vault-dr"

  # PVWA locals
  pvwa_instance_name     = "[PAMonCloud_TF] PVWA"
  pvwa_instance_type     = "m5.xlarge"
  pvwa_instance_hostname = "pvwa"

  # CPM locals
  cpm_instance_name     = "[PAMonCloud_TF] CPM"
  cpm_instance_type     = "m5.xlarge"
  cpm_instance_hostname = "cpm"

  # PSM locals
  psm_instance_name     = "[PAMonCloud_TF] PSM"
  psm_instance_type     = "m5.xlarge"
  psm_instance_hostname = "psm"

  # PSMP locals
  psmp_instance_name     = "[PAMonCloud_TF] PSMP"
  psmp_instance_type     = "m5.xlarge"
  psmp_instance_hostname = "psmp"

  # PTA locals
  pta_instance_name     = "[PAMonCloud_TF] PTA"
  pta_instance_type     = "m5.xlarge"
  pta_instance_hostname = "pta"
}

provider "aws" {
  region = local.region
}

################################################################################
# pam_network Module
################################################################################
module "pam_network" {
  source                     = "../../../modules/aws/network/pam_network"
  pam_vpc_cidr               = local.pam_vpc_cidr
  network_type               = local.network_type
  users_access_cidr          = local.users_access_cidr
  administrative_access_cidr = local.administrative_access_cidr
}

################################################################################
# deploy_prerequisites Module
################################################################################
module "deploy_prep" {
  source = "../../../modules/aws/components/deploy_prerequisites"
}

################################################################################
# vault Module
################################################################################
module "vault_instance" {
  source                         = "../../../modules/aws/components/vault"
  instance_name                  = local.vault_instance_name
  instance_type                  = local.vault_instance_type
  key_name                       = var.key_name
  subnet_id                      = module.pam_network.private_subnets_map["Vault Main Subnet"].id
  vpc_security_group_ids         = [module.pam_network.security_group_ids["Vault"]]
  custom_ami_id                  = var.vault_custom_ami_id
  vault_files_bucket             = var.vault_files_bucket
  license_file                   = local.vault_license_file
  recovery_public_key_file       = local.vault_recovery_public_key_file
  instance_hostname              = local.vault_instance_hostname
  vault_master_password          = var.vault_master_password
  vault_admin_password           = var.vault_admin_password
  vault_dr_password              = var.vault_dr_password
  vault_dr_secret                = var.vault_dr_secret
  log_group_name                 = module.deploy_prep.log_group_name
  manage_ssm_password_lambda     = module.deploy_prep.manage_ssm_password_lambda
  retrieve_success_signal_lambda = module.deploy_prep.retrieve_success_signal_lambda
  remove_permissions_lambda      = module.deploy_prep.remove_permissions_lambda
  depends_on                     = [module.deploy_prep, module.pam_network]
}

################################################################################
# vault_dr Module
################################################################################
module "vault_dr_instance" {
  source                         = "../../../modules/aws/components/vault_dr"
  instance_name                  = local.vaultdr_instance_name
  instance_type                  = local.vaultdr_instance_type
  key_name                       = var.key_name
  subnet_id                      = module.pam_network.private_subnets_map["Vault DR Subnet"].id
  vpc_security_group_ids         = [module.pam_network.security_group_ids["Vault"]]
  custom_ami_id                  = var.vault_custom_ami_id
  primary_vault_ip               = module.vault_instance.instance_ip_address
  instance_hostname              = local.vaultdr_instance_hostname
  vault_dr_password              = var.vault_dr_password
  vault_dr_secret                = var.vault_dr_secret
  log_group_name                 = module.deploy_prep.log_group_name
  manage_ssm_password_lambda     = module.deploy_prep.manage_ssm_password_lambda
  retrieve_success_signal_lambda = module.deploy_prep.retrieve_success_signal_lambda
  remove_permissions_lambda      = module.deploy_prep.remove_permissions_lambda
  depends_on                     = [module.vault_instance]
}

################################################################################
# component Module
################################################################################
module "pvwa_instance" {
  source                         = "../../../modules/aws/components/component"
  instance_name                  = local.pvwa_instance_name
  instance_type                  = local.pvwa_instance_type
  key_name                       = var.key_name
  subnet_id                      = module.pam_network.private_subnets_map["PVWA Main Subnet"].id
  vpc_security_group_ids         = [module.pam_network.security_group_ids["PVWA"]]
  custom_ami_id                  = var.pvwa_custom_ami_id
  primary_vault_ip               = module.vault_instance.instance_ip_address
  vault_dr_ip                    = module.vault_dr_instance.instance_ip_address
  instance_hostname              = local.pvwa_instance_hostname
  component                      = "PVWA"
  vault_admin_username           = local.vault_admin_username
  vault_admin_password           = var.vault_admin_password
  log_group_name                 = module.deploy_prep.log_group_name
  manage_ssm_password_lambda     = module.deploy_prep.manage_ssm_password_lambda
  retrieve_success_signal_lambda = module.deploy_prep.retrieve_success_signal_lambda
  depends_on                     = [module.vault_dr_instance]
}

module "cpm_instance" {
  source                         = "../../../modules/aws/components/component"
  instance_name                  = local.cpm_instance_name
  instance_type                  = local.cpm_instance_type
  key_name                       = var.key_name
  subnet_id                      = module.pam_network.private_subnets_map["CPM Main Subnet"].id
  vpc_security_group_ids         = [module.pam_network.security_group_ids["CPM"]]
  custom_ami_id                  = var.cpm_custom_ami_id
  primary_vault_ip               = module.vault_instance.instance_ip_address
  vault_dr_ip                    = module.vault_dr_instance.instance_ip_address
  instance_hostname              = local.cpm_instance_hostname
  component                      = "CPM"
  vault_admin_username           = local.vault_admin_username
  vault_admin_password           = var.vault_admin_password
  log_group_name                 = module.deploy_prep.log_group_name
  manage_ssm_password_lambda     = module.deploy_prep.manage_ssm_password_lambda
  retrieve_success_signal_lambda = module.deploy_prep.retrieve_success_signal_lambda
  depends_on                     = [module.pvwa_instance]
}

module "psm_instance" {
  source                         = "../../../modules/aws/components/component"
  instance_name                  = local.psm_instance_name
  instance_type                  = local.psm_instance_type
  key_name                       = var.key_name
  subnet_id                      = module.pam_network.private_subnets_map["PSM Main Subnet"].id
  vpc_security_group_ids         = [module.pam_network.security_group_ids["PSM"]]
  custom_ami_id                  = var.psm_custom_ami_id
  primary_vault_ip               = module.vault_instance.instance_ip_address
  vault_dr_ip                    = module.vault_dr_instance.instance_ip_address
  instance_hostname              = local.psm_instance_hostname
  component                      = "PSM"
  vault_admin_username           = local.vault_admin_username
  vault_admin_password           = var.vault_admin_password
  log_group_name                 = module.deploy_prep.log_group_name
  manage_ssm_password_lambda     = module.deploy_prep.manage_ssm_password_lambda
  retrieve_success_signal_lambda = module.deploy_prep.retrieve_success_signal_lambda
  depends_on                     = [module.cpm_instance]
}

module "psmp_instance" {
  source                         = "../../../modules/aws/components/component"
  instance_name                  = local.psmp_instance_name
  instance_type                  = local.psmp_instance_type
  key_name                       = var.key_name
  subnet_id                      = module.pam_network.private_subnets_map["PSMP Main Subnet"].id
  vpc_security_group_ids         = [module.pam_network.security_group_ids["PSMP"]]
  custom_ami_id                  = var.psmp_custom_ami_id
  primary_vault_ip               = module.vault_instance.instance_ip_address
  vault_dr_ip                    = module.vault_dr_instance.instance_ip_address
  instance_hostname              = local.psmp_instance_hostname
  component                      = "PSMP"
  vault_admin_username           = local.vault_admin_username
  vault_admin_password           = var.vault_admin_password
  log_group_name                 = module.deploy_prep.log_group_name
  manage_ssm_password_lambda     = module.deploy_prep.manage_ssm_password_lambda
  retrieve_success_signal_lambda = module.deploy_prep.retrieve_success_signal_lambda
  depends_on                     = [module.cpm_instance]
}

module "pta_instance" {
  source                         = "../../../modules/aws/components/component"
  instance_name                  = local.pta_instance_name
  instance_type                  = local.pta_instance_type
  key_name                       = var.key_name
  subnet_id                      = module.pam_network.private_subnets_map["PTA Main Subnet"].id
  vpc_security_group_ids         = [module.pam_network.security_group_ids["PTA"]]
  custom_ami_id                  = var.pta_custom_ami_id
  primary_vault_ip               = module.vault_instance.instance_ip_address
  vault_dr_ip                    = module.vault_dr_instance.instance_ip_address
  pvwa_private_dns               = module.pvwa_instance.instance_private_dns
  instance_hostname              = local.pta_instance_hostname
  component                      = "PTA"
  vault_admin_username           = local.vault_admin_username
  vault_admin_password           = var.vault_admin_password
  log_group_name                 = module.deploy_prep.log_group_name
  manage_ssm_password_lambda     = module.deploy_prep.manage_ssm_password_lambda
  retrieve_success_signal_lambda = module.deploy_prep.retrieve_success_signal_lambda
  depends_on                     = [module.pvwa_instance]
}
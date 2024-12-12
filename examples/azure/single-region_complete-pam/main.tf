locals {
  # Network locals:
  resource_group_name        = "PAMonCloud-TF-single-region_complete-pam-RG"
  vnet_cidr_primary          = "10.0.0.0/16"
  vnet_location_primary      = "westeurope"
  users_access_cidr          = "192.168.0.0/16"
  administrative_access_cidr = "192.168.1.0/24"

  # General locals:
  vault_admin_username = "Administrator"
  vm_admin_user        = "azureadmin"

  # Primary Vault locals:
  vault_vm_name                  = "PAMonCloud-TF-PrimaryVault"
  vault_vm_hostname              = "vault"
  vault_vm_size                  = "Standard_D8s_v3"
  vault_availability_zone        = ["1"]
  vault_key_vault_name           = "primaryvault-key-vault"
  storage_account_name           = "pamoncloudstorageacc"
  container_name                 = "pamoncloud-container"
  vault_license_file             = "license.xml"
  vault_recovery_public_key_file = "recpub.key"

  # DR Vault locals:
  vaultdr_vm_name        = "PAMonCloud-TF-VaultDR"
  vaultdr_vm_hostname    = "vault-dr"
  vaultdr_vm_size        = "Standard_D8s_v3"
  vaultdr_key_vault_name = "vault-dr-key-vault"

  # PVWA locals:
  pvwa_vm_name     = "PAMonCloud-TF-PVWA"
  pvwa_vm_hostname = "PVWA"
  pvwa_vm_size     = "Standard_D4s_v3"

  # CPM locals:
  cpm_vm_name     = "PAMonCloud-TF-CPM"
  cpm_vm_hostname = "CPM"
  cpm_vm_size     = "Standard_D4s_v3"

  # PSM locals:
  psm_vm_name     = "PAMonCloud-TF-PSM"
  psm_vm_hostname = "PSM"
  psm_vm_size     = "Standard_F8s_v2"

  # PSMP locals:
  psmp_vm_name     = "PAMonCloud-TF-PSMP"
  psmp_vm_hostname = "PSMP"
  psmp_vm_size     = "Standard_D4s_v3"

  # PTA locals:
  pta_vm_name     = "PAMonCloud-TF-PTA"
  pta_vm_hostname = "PTA"
  pta_vm_size     = "Standard_D4s_v3"
}

provider "azurerm" {
  features {}
}

################################################################################
# pam_network Module
################################################################################
module "pam-network" {
  source = "../../../modules/azure/network/pam_network"

  resource_group_name        = local.resource_group_name
  vnet_location_primary      = local.vnet_location_primary
  vnet_cidr_primary          = local.vnet_cidr_primary
  users_access_cidr          = local.users_access_cidr
  administrative_access_cidr = local.administrative_access_cidr
}

################################################################################
# vault Module
################################################################################
module "vault_vm" {
  source = "../../../modules/azure/components/vault"

  vm_name             = local.vault_vm_name
  vm_hostname         = local.vault_vm_hostname
  vm_size             = local.vault_vm_size
  resource_group_name = module.pam-network.rg_name
  location            = module.pam-network.vnet_location.primary
  availability_zone   = local.vault_availability_zone
  subnet_id = {
    primary = module.pam-network.vault_subnet_id.primary
    peered  = module.pam-network.vault_subnet_id.peered
  }
  vm_admin_user              = local.vm_admin_user
  vm_admin_password          = var.vm_admin_password
  image_id                   = var.vault_image_id
  storage_account_name       = local.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  container_name             = local.container_name
  license_file               = local.vault_license_file
  recovery_public_key_file   = local.vault_recovery_public_key_file
  key_vault_name             = local.vault_key_vault_name
  vault_master_password      = var.vault_master_password
  vault_admin_password       = var.vault_admin_password
  vault_dr_password          = var.vault_dr_password
  vault_dr_secret            = var.vault_dr_secret

  depends_on = [module.pam-network]
}

################################################################################
# vault_dr Module
################################################################################
module "vault_dr_vm" {
  source = "../../../modules/azure/components/vault_dr"

  vm_name             = local.vaultdr_vm_name
  vm_hostname         = local.vaultdr_vm_hostname
  vm_size             = local.vaultdr_vm_size
  resource_group_name = module.pam-network.rg_name
  location            = module.pam-network.vnet_location.peered == null ? module.pam-network.vnet_location.primary : module.pam-network.vnet_location.peered
  availability_zone   = [module.vault_vm.availability_zone == "1" ? "2" : "1"]
  subnet_id = {
    primary = module.pam-network.vault_subnet_id.primary
    peered  = module.pam-network.vault_subnet_id.peered
  }
  vm_admin_user            = local.vm_admin_user
  vm_admin_password        = var.vm_admin_password
  image_id                 = var.vault_dr_image_id
  key_vault_name           = local.vaultdr_key_vault_name
  vault_dr_password        = var.vault_dr_password
  vault_dr_secret          = var.vault_dr_secret
  primary_vault_private_ip = module.vault_vm.private_ip

  depends_on = [module.pam-network, module.vault_vm]
}

################################################################################
# component Module
################################################################################

#############
### PVWA ####
#############
module "pvwa_vm" {
  source = "../../../modules/azure/components/component"

  vm_name                  = local.pvwa_vm_name
  vm_hostname              = local.pvwa_vm_hostname
  vm_size                  = local.pvwa_vm_size
  resource_group_name      = module.pam-network.rg_name
  location                 = module.pam-network.vnet_location.primary
  availability_zone        = module.vault_vm.availability_zone
  subnet_id                = module.pam-network.pvwa_subnet_id.primary
  vm_admin_user            = local.vm_admin_user
  vm_admin_password        = var.vm_admin_password
  image_id                 = var.pvwa_image_id
  component                = "PVWA"
  vault_admin_username     = local.vault_admin_username
  vault_admin_password     = var.vault_admin_password
  primary_vault_private_ip = module.vault_vm.private_ip

  depends_on = [module.vault_dr_vm]
}

############
### CPM ####
############
module "cpm_vm" {
  source = "../../../modules/azure/components/component"

  vm_name                  = local.cpm_vm_name
  vm_hostname              = local.cpm_vm_hostname
  vm_size                  = local.cpm_vm_size
  resource_group_name      = module.pam-network.rg_name
  location                 = module.pam-network.vnet_location.primary
  availability_zone        = module.vault_vm.availability_zone
  subnet_id                = module.pam-network.cpm_subnet_id.primary
  vm_admin_user            = local.vm_admin_user
  vm_admin_password        = var.vm_admin_password
  image_id                 = var.cpm_image_id
  component                = "CPM"
  vault_admin_username     = local.vault_admin_username
  vault_admin_password     = var.vault_admin_password
  primary_vault_private_ip = module.vault_vm.private_ip

  depends_on = [module.pvwa_vm]
}

############
### PSM ####
############
module "psm_vm" {
  source = "../../../modules/azure/components/component"

  vm_name                  = local.psm_vm_name
  vm_hostname              = local.psm_vm_hostname
  vm_size                  = local.psm_vm_size
  resource_group_name      = module.pam-network.rg_name
  location                 = module.pam-network.vnet_location.primary
  availability_zone        = module.vault_vm.availability_zone
  subnet_id                = module.pam-network.psm_subnet_id.primary
  vm_admin_user            = local.vm_admin_user
  vm_admin_password        = var.vm_admin_password
  image_id                 = var.psm_image_id
  component                = "PSM"
  vault_admin_username     = local.vault_admin_username
  vault_admin_password     = var.vault_admin_password
  primary_vault_private_ip = module.vault_vm.private_ip

  depends_on = [module.cpm_vm]
}

#############
### PSMP ####
#############
module "psmp_vm" {
  source = "../../../modules/azure/components/component"

  vm_name                  = local.psmp_vm_name
  vm_hostname              = local.psmp_vm_hostname
  vm_size                  = local.psmp_vm_size
  resource_group_name      = module.pam-network.rg_name
  location                 = module.pam-network.vnet_location.primary
  availability_zone        = module.vault_vm.availability_zone
  subnet_id                = module.pam-network.psmp_subnet_id.primary
  vm_admin_user            = local.vm_admin_user
  vm_admin_password        = var.vm_admin_password
  image_id                 = var.psmp_image_id
  component                = "PSMP"
  vault_admin_username     = local.vault_admin_username
  vault_admin_password     = var.vault_admin_password
  primary_vault_private_ip = module.vault_vm.private_ip

  depends_on = [module.cpm_vm]
}

############
### PTA ####
############
module "pta_vm" {
  source = "../../../modules/azure/components/component"

  vm_name                  = local.pta_vm_name
  vm_hostname              = local.pta_vm_hostname
  vm_size                  = local.pta_vm_size
  resource_group_name      = module.pam-network.rg_name
  location                 = module.pam-network.vnet_location.primary
  availability_zone        = module.vault_vm.availability_zone
  subnet_id                = module.pam-network.pta_subnet_id.primary
  vm_admin_user            = local.vm_admin_user
  vm_admin_password        = var.vm_admin_password
  image_id                 = var.pta_image_id
  component                = "PTA"
  vault_admin_username     = local.vault_admin_username
  vault_admin_password     = var.vault_admin_password
  primary_vault_private_ip = module.vault_vm.private_ip
  pvwa_vm_hostname         = module.pvwa_vm.vm_hostname
  vault_dr_private_ip      = module.vault_dr_vm.private_ip

  depends_on = [module.pvwa_vm]
}
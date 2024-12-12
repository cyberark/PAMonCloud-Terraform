locals {
  # General locals:
  vault_admin_username = "Administrator"
  vm_admin_user        = "azureadmin"

  # Component locals:
  component_vm_name     = "PAMonCloud-TF-${var.component}"
  component_vm_hostname = lower(var.component)
  component_vm_size     = "Standard_D8s_v3"
}

provider "azurerm" {
  features {}
}

################################################################################
# component Module
################################################################################
module "component_vm" {
  source = "../../../modules/azure/components/component"

  vm_name                  = local.component_vm_name
  vm_hostname              = local.component_vm_hostname
  vm_size                  = local.component_vm_size
  resource_group_name      = var.resource_group_name
  location                 = var.component_location
  availability_zone        = var.component_availability_zone
  subnet_id                = var.component_subnet_id
  vm_admin_user            = local.vm_admin_user
  vm_admin_password        = var.component_vm_admin_password
  image_id                 = var.component_image_id
  component                = var.component
  primary_vault_private_ip = var.primary_vault_private_ip
  vault_admin_username     = local.vault_admin_username
  vault_admin_password     = var.vault_admin_password
  vault_dr_private_ip      = var.vault_dr_private_ip
  pvwa_vm_hostname         = var.pvwa_vm_hostname
}
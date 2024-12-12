variable "component" {
  description = "The name of the PAM component."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the RG."
  type        = string
}

variable "vault_admin_password" {
  description = "Primary Vault Admin Password."
  type      = string
  sensitive = true
}

variable "primary_vault_private_ip" {
  description = "The private IP address of the Primary Vault."
  type      = string
  sensitive = true
}

variable "vault_dr_private_ip" {
  description = "The private IP address of the DR Vault. (Required only when component is PTA)"
  type        = string
  default = ""
}

variable "pvwa_vm_hostname" {
  description = "The hostname of the PVWA VM. (Required only when component is PTA)"
  type        = string
  default = ""
}

variable "component_vm_admin_password" {
  description = "Admin password for the VM."
  type      = string
  sensitive = true
}

variable "component_subnet_id" {
  description = "Subnet ID where the Vault VM can reside."
  type = string
}

variable "component_location" {
  description = "The location to deploy the VM."
  type = string
}

variable "component_availability_zone" {
  description = "The availability zone of the VM."
  type = list(string)
}

variable "component_image_id" {
  description = "Image ID to use for the VM deployment."
  type = string
}
variable "vm_admin_password" {
  description = "Admin password for the VM."
  type      = string
  sensitive = true
}

variable "vault_master_password" {
  description = "Primary Vault Master Password."
  type      = string
  sensitive = true
}

variable "vault_admin_password" {
  description = "Primary Vault Admin Password."
  type      = string
  sensitive = true
}

variable "vault_dr_password" {
  description = "Vault DR User Password."
  type      = string
  sensitive = true
}

variable "vault_dr_secret" {
  description = "Vault DR User Secret."
  type      = string
  sensitive = true
}

variable "storage_account_access_key" {
  description = "The access key for the storage account that contains the Vault license and recovery key."
  type      = string
  sensitive = true
}

variable "vault_image_id" {
  description = "Image ID to use for the VM deployment."
  type        = string
  default     = ""
}

variable "vault_dr_image_id" {
  description = "Image ID to use for the VM deployment."
  type        = string
  default     = ""
}

variable "pvwa_image_id" {
  description = "Image ID to use for the VM deployment."
  type        = string
  default     = ""
}

variable "cpm_image_id" {
  description = "Image ID to use for the VM deployment."
  type        = string
  default     = ""
}

variable "psm_image_id" {
  description = "Image ID to use for the VM deployment."
  type        = string
  default     = ""
}

variable "psmp_image_id" {
  description = "Image ID to use for the VM deployment."
  type        = string
  default     = ""
}

variable "pta_image_id" {
  description = "Image ID to use for the VM deployment."
  type        = string
  default     = ""
}
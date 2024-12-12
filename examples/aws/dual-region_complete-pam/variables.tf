variable "key_name" {
  description = "The name of the EC2 key pair to use."
  type        = string
}

variable "vault_files_bucket" {
  description = "The name of the S3 bucket where Vault license and recovery key are stored."
  type        = string
}

variable "vault_master_password" {
  description = "Primary Vault Master Password."
  type        = string
  sensitive   = true
}

variable "vault_admin_password" {
  description = "Primary Vault Admin Password."
  type        = string
  sensitive   = true
}

variable "vault_dr_password" {
  description = "Vault DR User Password."
  type        = string
  sensitive   = true
}

variable "vault_dr_secret" {
  description = "Vault DR User Secret."
  type        = string
  sensitive   = true
}

variable "vault_custom_ami_id" {
  description = "Custom AMI ID to use instead of the default one. (Optional)"
  type        = string
  default     = ""
}

variable "vault_dr_custom_ami_id" {
  description = "Custom AMI ID to use instead of the default one. (Optional)"
  type        = string
  default     = ""
}

variable "pvwa_custom_ami_id" {
  description = "Custom AMI ID to use instead of the default one. (Optional)"
  type        = string
  default     = ""
}

variable "cpm_custom_ami_id" {
  description = "Custom AMI ID to use instead of the default one. (Optional)"
  type        = string
  default     = ""
}

variable "psm_custom_ami_id" {
  description = "Custom AMI ID to use instead of the default one. (Optional)"
  type        = string
  default     = ""
}

variable "psmp_custom_ami_id" {
  description = "Custom AMI ID to use instead of the default one. (Optional)"
  type        = string
  default     = ""
}

variable "pta_custom_ami_id" {
  description = "Custom AMI ID to use instead of the default one. (Optional)"
  type        = string
  default     = ""
}
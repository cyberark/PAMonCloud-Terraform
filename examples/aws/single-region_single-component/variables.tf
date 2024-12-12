variable "component" {
  description = "The name of the PAM component."
  type        = string
}

variable "key_name" {
  description = "The name of the EC2 key pair to use."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet in which the EC2 instance will be launched."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with the EC2 instance."
  type        = list(string)
}

variable "primary_vault_ip" {
  description = "The IP address of the primary Vault."
  type        = string
}

variable "vault_dr_ip" {
  description = "The IP address of Vault DR. (Optional)"
  type        = string
  default     = ""
}

variable "vault_admin_password" {
  description = "Primary Vault Admin Password."
  type        = string
  sensitive   = true
}

variable "pvwa_private_dns" {
  description = "The private DNS of the PVWA Instance. (Required only when component is PTA)"
  type        = string
  default     = ""
}

variable "component_custom_ami_id" {
  description = "Custom AMI ID to use instead of the default one. (Optional)"
  type        = string
  default     = ""
}
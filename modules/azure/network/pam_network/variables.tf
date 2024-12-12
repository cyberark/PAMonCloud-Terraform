variable "resource_group_name" {
  description = "The name of the RG."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-_()]{1,89}$", var.resource_group_name))
    error_message = <<-EOF
      The resource group name must meet the following requirements:
        - Be between 1 and 90 characters long.
        - Start with a letter
        - Contain only alphanumeric characters, underscores (_), hyphens (-), or parentheses (()).
    EOF
  }
}

variable "vnet_location_primary" {
  description = "The location of the primary VNet."
  type        = string
}

variable "vnet_cidr_primary" {
  description = "The CIDR of the primary VNet."
  type        = string
}

variable "vnet_location_peered" {
  description = "The location of the peered VNet. (Optional)"
  type        = string
  default     = ""
}

variable "vnet_cidr_peered" {
  description = "The CIDR of the peered VNet. (Optional)"
  type        = string
  default     = ""
}

variable "administrative_access_cidr" {
  description = "Allowed IPv4 address range for Remote Desktop administrative access to CyberArk VMs."
  type        = string
  validation {
    condition     = can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/([0-9]|[1-2][0-9]|3[0-2]))$", var.administrative_access_cidr))
    error_message = "Must be a valid IP CIDR range of the form x.x.x.x/x."
  }
}

variable "users_access_cidr" {
  description = "Allowed IPv4 address range for users access to CyberArk components"
  type        = string
  validation {
    condition     = can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/([0-9]|[1-2][0-9]|3[0-2]))$", var.users_access_cidr))
    error_message = "Must be a valid IP CIDR range of the form x.x.x.x/x."
  }
}
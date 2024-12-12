variable "pam_vpc_cidr" {
  type = string
}

variable "users_access_cidr" {
  description = "Allowed IPv4 address range for users access to CyberArk components"
  type        = string
  validation {
    condition     = can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/([0-9]|[1-2][0-9]|3[0-2]))$", var.users_access_cidr))
    error_message = "Must be a valid IP CIDR range of the form x.x.x.x/x."
  }
}

variable "administrative_access_cidr" {
  description = "Allowed IPv4 address range for Remote Desktop administrative access to CyberArk instances"
  type        = string
  validation {
    condition     = can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/([0-9]|[1-2][0-9]|3[0-2]))$", var.administrative_access_cidr))
    error_message = "Must be a valid IP CIDR range of the form x.x.x.x/x."
  }
}

variable "network_type" {
  description = "The type of networking to deploy. Valid options: 'privatelink' or 'nat'"
  type        = string
  validation {
    condition     = contains(["privatelink", "nat"], lower(var.network_type))
    error_message = "Invalid network type. Valid options are: 'privatelink', 'nat'"
  }
}
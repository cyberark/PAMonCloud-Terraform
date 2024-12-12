variable "vm_name" {
  description = "The name of the VM."
  type        = string
}

variable "vm_hostname" {
  description = "The hostname for the VM."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{1,13}[a-zA-Z0-9]$", var.vm_hostname))
    error_message = "VM hostname must be 3 to 15 characters long, contain at least one letter, and must not start or end with a hyphen."
  }
}

variable "vm_size" {
  description = "The size of the VM."
  type        = string
  validation {
    condition     = contains(["Standard_D8s_v3", "Standard_D16s_v3", "Standard_D32s_v3", "Standard_D64s_v3", "Standard_D4s_v3", "Standard_D8s_v3", "Standard_D16s_v3", "Standard_D32s_v3", "Standard_F8s_v2", "Standard_F16s_v2", "Standard_F32s_v2"], var.vm_size)
    error_message = "Invalid instance size. Allowed sizes are: Standard_D8s_v3, Standard_D16s_v3, Standard_D32s_v3, Standard_D64s_v3, Standard_D4s_v3, Standard_D8s_v3, Standard_D16s_v3, Standard_D32s_v3, Standard_F8s_v2, Standard_F16s_v2, Standard_F32s_v2"
  }
}

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

variable "location" {
  description = "The location to deploy the VM."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{5,}$", var.location))
    error_message = <<-EOF
      The location must be a valid Azure region name, matching these characteristics:
        - Lowercase letters only.
        - Alphanumeric characters and hyphens (-) are allowed.
        - No spaces or special characters.
    EOF
  }
}

variable "availability_zone" {
  description = "The availability zone of the VM."
  type        = list(string)
  default     = ["1"]
  validation {
    condition = can(
      regex("^(?:$|[123])$", join("", var.availability_zone))
    )
    error_message = <<-EOF
      The availability_zone can be a single-element list containing one of: "1", "2", or "3".
      Set the variable value to an empty list ([]) in case availability zone not supported in the selected location.
    EOF
  }
}

variable "subnet_id" {
  description = "Subnet ID where the Vault VM can reside."
  type = object({
    primary = string
    peered  = optional(string)
  })
  validation {
    condition = can(
      regex("^/subscriptions/[0-9a-fA-F-]+/resourceGroups/[a-zA-Z0-9-_()]+/providers/Microsoft.Network/virtualNetworks/[a-zA-Z0-9-_()]+/subnets/[a-zA-Z0-9-_()]+$", var.subnet_id.primary)
      ) && (
      var.subnet_id.peered == null || can(
        regex("^/subscriptions/[0-9a-fA-F-]+/resourceGroups/[a-zA-Z0-9-_()]+/providers/Microsoft.Network/virtualNetworks/[a-zA-Z0-9-_()]+/subnets/[a-zA-Z0-9-_()]+$", var.subnet_id.peered)
      )
    )
    error_message = <<-EOF
      The provided subnet ID must follow the Azure subnet ID format:
      /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}
    EOF
  }
}

variable "vm_admin_user" {
  description = "Admin username for the VM."
  type        = string
  validation {
    condition = (
      can(regex("^[a-zA-Z0-9_.-]{1,20}$", var.vm_admin_user)) &&
      !can(regex("^(Administrator|Guest|DefaultAccount|System)$", var.vm_admin_user))
    )
    error_message = <<-EOF
      The admin username must meet the following requirements:
        - Be between 1 and 20 characters long.
        - Contain only alphanumeric characters, underscores (_), hyphens (-), or periods (.).
        - Must not contain disallowed characters: \ / [ ] : ; | = , + * ? < > @ "
        - Cannot use reserved usernames such as Administrator, Guest, DefaultAccount, or System.
    EOF
  }
}

variable "vm_admin_password" {
  description = "Admin password for the VM."
  type        = string
  sensitive   = true
  validation {
    condition     = can(regex("^.{12,123}$", var.vm_admin_password))
    error_message = "Password must be between 12 and 123 characters long."
  }
  validation {
    condition     = can(regex("[A-Z]", var.vm_admin_password))
    error_message = "Password must contain at least one uppercase letter."
  }
  validation {
    condition     = can(regex("[a-z]", var.vm_admin_password))
    error_message = "Password must contain at least one lowercase letter."
  }
  validation {
    condition     = can(regex("[~!@#$%\\^&*()=+_\\[\\]{}\\\\|;:\\.'\"<>,/?]", var.vm_admin_password))
    error_message = "Password must contain at least one special character."
  }
  validation {
    condition     = can(regex("[0-9]", var.vm_admin_password))
    error_message = "Password must contain at least one digit."
  }
}

variable "image_id" {
  description = "VM image ID."
  type        = string
  validation {
    condition = can(
    regex("^/subscriptions/[0-9a-fA-F-]{36}/resourceGroups/[a-zA-Z0-9_.-]+/providers/Microsoft.Compute/images/[a-zA-Z0-9-._()]+$", var.image_id))
    error_message = <<-EOF
      The image_id must be a valid Azure image resource ID in the following format:
      /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}
    EOF
  }
}

variable "storage_account_name" {
  description = "The name of the storage account which hosts the container with the Vault license and recovery key."
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9]{2,23}$", var.storage_account_name))
    error_message = <<-EOF
      The storage account name must meet the following requirements:
        - Be between 3 and 24 characters long.
        - Contain only lowercase letters (a-z) and numbers (0-9).
        - Start with a letter.
        - Must not contain uppercase letters, hyphens, underscores, or special characters.
    EOF
  }
}

variable "storage_account_access_key" {
  description = "The access key for the storage account that contains the Vault license and recovery key."
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[a-zA-Z0-9+/=]+$", var.storage_account_access_key))
    error_message = <<EOF
      The storage account access key must meet the following requirements:
        - Contain only Base64 characters: uppercase letters (A-Z), lowercase letters (a-z), numbers (0-9), and the symbols +, /, =.
        - Must not contain spaces or invalid characters.
    EOF
  }
}

variable "container_name" {
  description = "The name of the container in the storage account where Vault license and recovery key are stored."
  type        = string
  validation {
    condition     = can(regex("^.{3,36}$", var.container_name))
    error_message = "Password must be between 3 and 63 characters long."
  }
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.container_name))
    error_message = "Contain only lowercase letters (a-z), numbers (0-9), and hyphens (-)"
  }
  validation {
    condition     = can(regex("^[a-z0-9]", var.container_name))
    error_message = "Start with a lowercase letter or number."
  }
  validation {
    condition     = can(regex("[a-z0-9]$", var.container_name))
    error_message = "Must not end with a hyphen."
  }
}

variable "license_file" {
  description = "The name of the license file stored in the storage account container."
  type        = string
  default     = "license.xml"
  validation {
    condition     = can(regex("^[^\\/:*?\"<>|]+$", var.license_file))
    error_message = "License file name must not contain any of the following characters: \\ / : * ? \" < > |"
  }
}

variable "recovery_public_key_file" {
  description = "The name of the recovery public key file stored in the storage account container."
  type        = string
  default     = "recpub.key"
  validation {
    condition     = can(regex("^[^\\/:*?\"<>|]+$", var.recovery_public_key_file))
    error_message = "Recovery public key file name must not contain any of the following characters: \\ / : * ? \" < > |"
  }
}

variable "key_vault_name" {
  description = "The key vault name."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,22}[a-z0-9]$", var.key_vault_name))
    error_message = <<EOF
    The key vault name must be:
      - Globally unique.
      - Between 3 and 24 characters long.
      - Contain only alphanumeric characters (a-z, 0-9) and hyphens (-).
      - Start with a lowercase letter or number.
      - Must not end with a hyphen (-).
    EOF
  }
}

variable "vault_master_password" {
  description = "Primary Vault Master Password."
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.vault_master_password) >= 10
    error_message = "Password must have at least 10 characters."
  }
  validation {
    condition     = can(regex("[A-Z]", var.vault_master_password))
    error_message = "Password must contain at least one uppercase letter."
  }
  validation {
    condition     = can(regex("[a-z]", var.vault_master_password))
    error_message = "Password must contain at least one lowercase letter."
  }
  validation {
    condition     = can(regex("[^a-zA-Z0-9]", var.vault_master_password))
    error_message = "Password must contain at least one special character."
  }
  validation {
    condition     = can(regex("[0-9]", var.vault_master_password))
    error_message = "Password must contain at least one digit."
  }
}

variable "vault_admin_password" {
  description = "Primary Vault Admin Password."
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.vault_admin_password) >= 10
    error_message = "Password must have at least 10 characters."
  }
  validation {
    condition     = can(regex("[A-Z]", var.vault_admin_password))
    error_message = "Password must contain at least one uppercase letter."
  }
  validation {
    condition     = can(regex("[a-z]", var.vault_admin_password))
    error_message = "Password must contain at least one lowercase letter."
  }
  validation {
    condition     = can(regex("[^a-zA-Z0-9]", var.vault_admin_password))
    error_message = "Password must contain at least one special character."
  }
  validation {
    condition     = can(regex("[0-9]", var.vault_admin_password))
    error_message = "Password must contain at least one digit."
  }
}

variable "vault_dr_password" {
  description = "Vault DR User Password."
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.vault_dr_password) >= 10
    error_message = "Password must have at least 10 characters."
  }
  validation {
    condition     = can(regex("[A-Z]", var.vault_dr_password))
    error_message = "Password must contain at least one uppercase letter."
  }
  validation {
    condition     = can(regex("[a-z]", var.vault_dr_password))
    error_message = "Password must contain at least one lowercase letter."
  }
  validation {
    condition     = can(regex("[^a-zA-Z0-9]", var.vault_dr_password))
    error_message = "Password must contain at least one special character."
  }
  validation {
    condition     = can(regex("[0-9]", var.vault_dr_password))
    error_message = "Password must contain at least one digit."
  }
}

variable "vault_dr_secret" {
  description = "Vault DR User Secret. (Required only for DR implementations)"
  type        = string
  sensitive   = true
  default     = ""
  validation {
    condition     = length(var.vault_dr_secret) >= 10
    error_message = "Secret must have at least 10 characters."
  }
  validation {
    condition     = can(regex("[A-Z]", var.vault_dr_secret))
    error_message = "Secret must contain at least one uppercase letter."
  }
  validation {
    condition     = can(regex("[a-z]", var.vault_dr_secret))
    error_message = "Secret must contain at least one lowercase letter."
  }
  validation {
    condition     = can(regex("[^a-zA-Z0-9]", var.vault_dr_secret))
    error_message = "Secret must contain at least one special character."
  }
  validation {
    condition     = can(regex("[0-9]", var.vault_dr_secret))
    error_message = "Secret must contain at least one digit."
  }
}
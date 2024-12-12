variable "instance_name" {
  description = "The name of the EC2 instance."
  type        = string
}

variable "instance_hostname" {
  description = "The hostname for the EC2 instance."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{1,13}[a-zA-Z0-9]$", var.instance_hostname))
    error_message = "Instance hostname must be 3 to 15 characters long, contain at least one letter, and must not start or end with a hyphen."
  }
}

variable "instance_type" {
  description = "The type of the EC2 instance. Allowed types are: c5.xlarge, m5.xlarge, c5.2xlarge, m5.2xlarge, c5.4xlarge, m5.4xlarge, c5.9xlarge, m5.8xlarge."
  type        = string
  validation {
    condition     = contains(["c5.xlarge", "m5.xlarge", "c5.2xlarge", "m5.2xlarge", "c5.4xlarge", "m5.4xlarge", "c5.9xlarge", "m5.8xlarge"], var.instance_type)
    error_message = "Invalid instance type. Allowed types are: c5.xlarge, m5.xlarge, c5.2xlarge, m5.2xlarge, c5.4xlarge, m5.4xlarge, c5.9xlarge, m5.8xlarge."
  }
}

variable "key_name" {
  description = "The name of the EC2 key pair to use."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]{1,255}$", var.key_name))
    error_message = "Key name must be between 1 and 255 characters long and can only contain alphanumeric characters, hyphens (-), and underscores (_)."
  }
}


variable "subnet_id" {
  description = "The ID of the subnet in which the EC2 instance will be launched."
  type        = string
  validation {
    condition     = can(regex("^subnet-[a-f0-9]{8,}$", var.subnet_id))
    error_message = "Subnet ID must be in the format 'subnet-xxxxxxxx' where 'x' is a hexadecimal digit."
  }
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with the EC2 instance."
  type        = list(string)
  validation {
    condition     = length(var.vpc_security_group_ids) > 0
    error_message = "At least one security group ID must be provided."
  }
  validation {
    condition     = alltrue([for sg in var.vpc_security_group_ids : can(regex("^sg-[a-f0-9]{8,}$", sg))])
    error_message = "Each provided security group ID must be in the format 'sg-xxxxxxxx' where 'x' is a hexadecimal digit."
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

variable "vault_files_bucket" {
  description = "The name of the S3 bucket where Vault license and recovery key are stored."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.vault_files_bucket))
    error_message = "Vault files bucket name must be between 3 and 63 characters long and can only contain lowercase letters, numbers, hyphens (-), and periods (.)."
  }
}

variable "license_file" {
  description = "The name of the license file stored in the S3 bucket."
  type        = string
  default     = "license.xml"
  validation {
    condition     = can(regex("^[^\\/:*?\"<>|]+$", var.license_file))
    error_message = "License file name must not contain any of the following characters: \\ / : * ? \" < > |"
  }
}

variable "recovery_public_key_file" {
  description = "The name of the recovery public key file stored in the S3 bucket."
  type        = string
  default     = "recpub.key"
  validation {
    condition     = can(regex("^[^\\/:*?\"<>|]+$", var.recovery_public_key_file))
    error_message = "Recovery public key file name must not contain any of the following characters: \\ / : * ? \" < > |"
  }
}

variable "custom_ami_id" {
  description = "Custom AMI ID to use instead of the default one. (Optional)"
  type        = string
  default     = ""
  validation {
    condition     = var.custom_ami_id == "" || can(regex("^ami-[a-f\\d]{8}(?:[a-f\\d]{9})?$|.{0,0}", var.custom_ami_id))
    error_message = "Custom AMI ID must start with 'ami-' followed by 8/17 hexadecimal digits."
  }
}

variable "log_group_name" {
  description = "The name of the CloudWatch log group."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_/\\-\\.#]{1,512}$", var.log_group_name))
    error_message = "Log group name must be between 1 and 512 characters long and can contain alphanumeric characters, as well as the following characters: _ - / . #"
  }
}

variable "manage_ssm_password_lambda" {
  description = "Required specs for the Lambda function that manages SSM passwords."
  type = object({
    function_name = string
  })
}

variable "retrieve_success_signal_lambda" {
  description = "Required specs for the Lambda function that retrieves success signals."
  type = object({
    function_name = string
  })
}

variable "remove_permissions_lambda" {
  description = "Required specs for the Lambda function that removes permissions."
  type = object({
    function_name = string
    arn           = string
    role_name     = string
  })
}
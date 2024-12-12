locals {
  component_data = {
    PVWA = {
      operating_system               = "windows",
      extension_publisher            = "Microsoft.Compute",
      extension_type                 = "CustomScriptExtension",
      extension_type_handler_version = "1.9",
      command_to_execute             = "powershell -ExecutionPolicy Unrestricted -File C:\\\\CyberArk\\\\componentregistration.ps1 ${var.component} ${var.primary_vault_private_ip} ${var.vault_admin_username} ${var.vault_admin_password}"
    },
    CPM = {
      operating_system               = "windows",
      extension_publisher            = "Microsoft.Compute",
      extension_type                 = "CustomScriptExtension",
      extension_type_handler_version = "1.9",
      command_to_execute             = "powershell -ExecutionPolicy Unrestricted -File C:\\\\CyberArk\\\\componentregistration.ps1 ${var.component} ${var.primary_vault_private_ip} ${var.vault_admin_username} ${var.vault_admin_password}"
    },
    PSM = {
      operating_system               = "windows",
      extension_publisher            = "Microsoft.Compute",
      extension_type                 = "CustomScriptExtension",
      extension_type_handler_version = "1.9",
      command_to_execute             = "powershell -ExecutionPolicy Unrestricted -File C:\\\\CyberArk\\\\componentregistration.ps1 ${var.component} ${var.primary_vault_private_ip} ${var.vault_admin_username} ${var.vault_admin_password}"
    },
    PSMP = {
      operating_system               = "linux",
      extension_publisher            = "Microsoft.Azure.Extensions",
      extension_type                 = "CustomScript",
      extension_type_handler_version = "2.0",
      command_to_execute             = "dos2unix /opt/CD-Image/register.sh && /opt/CD-Image/register.sh azure ${var.primary_vault_private_ip} ${random_uuid.random_suffix.id} ${var.vm_admin_user} ${var.vault_admin_username} ${var.vault_admin_password}"
    },
    PTA = {
      operating_system               = "linux",
      extension_publisher            = "Microsoft.Azure.Extensions",
      extension_type                 = "CustomScript",
      extension_type_handler_version = "2.0",
      command_to_execute             = "dos2unix /tmp/register.sh && . /tmp/register.sh azure  ${var.primary_vault_private_ip} ${var.pvwa_vm_hostname} ${var.vault_admin_username} ${var.vault_admin_password} ${var.vault_dr_private_ip}"
    }
  }
}
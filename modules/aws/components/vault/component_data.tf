locals {
  component_data = {
    Vault = {
      success_signal = "VaultMachine deployment process completed successfully",
      log_streams = [
        "Vault/VaultInitLog",
        "Vault/VaultPostInstallLog"
      ],
      user_data = <<-EOF
        <powershell>
        $UserDataParams = @{
            "IsPrimaryOrDR"             = "Primary"
            "VaultFilesBucket"          = "${var.vault_files_bucket}"
            "LicenseFileKey"            = "${var.license_file}"
            "RecoveryPublicKey"         = "${var.recovery_public_key_file}"
            "Region"                    = "${local.region}"
            "LogGroup"                  = "${var.log_group_name}"
            "UserDataLogStream"         = "${local.user_data_log_stream}"
            "VaultInitLogStream"        = "Vault/VaultInitLog"
            "VaultPostInstallLogStream" = "Vault/VaultPostInstallLog"
            "SSMMasterPassParameterID"  = "${local.master_password_ssm_id}"
            "SSMAdminPassParameterID"   = "${local.admin_password_ssm_id}"
            "SSMDRPassParameterID"      = "${local.dr_password_ssm_id}"
            "SSMSecretParameterID"      = "${local.dr_secret_ssm_id}"
            "VaultInstancesRole"        = "${aws_iam_role.instance_role.name}"
            "VaultHostname"             = "${var.instance_hostname}"
        }

        C:\CyberArk\Deployment\UserDataScript.ps1 @UserDataParams
        </powershell>
    	EOF
    }
  }
}
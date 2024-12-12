locals {
  component_data = {
    VaultDR = {
      success_signal = "VaultDRMachine deployment process completed successfully",
      log_streams = [
        "VaultDR/VaultInitLog",
        "VaultDR/VaultPostInstallLog"
      ],
      user_data = <<-EOF
        <powershell>
        $UserDataParams = @{
          "IsPrimaryOrDR"             = "DR"
          "Region"                    = "${local.region}"
          "LogGroup"                  = "${var.log_group_name}"
          "UserDataLogStream"         = "${local.user_data_log_stream}"
          "VaultInitLogStream"        = "VaultDR/VaultInitLog"
          "VaultPostInstallLogStream" = "VaultDR/VaultPostInstallLog"
          "SSMDRPassParameterID"      = "${local.dr_password_ssm_id}"
          "SSMSecretParameterID"      = "${local.dr_secret_ssm_id}"
          "VaultPrivateIP"            = "${var.primary_vault_ip}"
          "VaultInstancesRole"        = "${aws_iam_role.instance_role.name}"
          "VaultHostname"             = "${var.instance_hostname}"
        }

        C:\CyberArk\Deployment\UserDataScript.ps1 @UserDataParams
        </powershell>
      EOF
    }
  }
}
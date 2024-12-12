locals {
  component_data = {
    PVWA = {
      success_signal = "PVWAMachine deployment process completed successfully",
      log_streams = [
        "PVWA/PVWAConfigurationLog",
        "PVWA/PVWARegistrationLog"
      ],
      user_data = <<-EOF
        <powershell>
        $UserDataParams = @{
          "Region"                        = "${local.region}"
          "LogGroup"                      = "${var.log_group_name}"
          "UserDataLogStream"             = "${local.user_data_log_stream}"
          "PVWAConfigurationLogStream"    = "PVWA/PVWAConfigurationLog"
          "PVWARegistrationLogStream"     = "PVWA/PVWARegistrationLog"
          "VaultAdminUser"                = "${var.vault_admin_username}"
          "SSMAdminPassParameterID"       = "${local.admin_password_ssm_id}"
          "VaultPrivateIP"                = "${local.vault_ips}"
          "ComponentHostname"             = "${var.instance_hostname}"
        }

        C:\CyberArk\Deployment\UserDataScript.ps1 @UserDataParams
        </powershell>
      EOF
    },
    CPM = {
      success_signal = "CPMMachine deployment process completed successfully",
      log_streams = [
        "CPM/CPMConfigurationLog",
        "CPM/CPMRegistrationLog",
        "CPM/CPMSetLocalServiceLog"
      ],
      user_data = <<-EOF
        <powershell>
        $UserDataParams = @{
          "Region"                        = "${local.region}"
          "LogGroup"                      = "${var.log_group_name}"
          "UserDataLogStream"             = "${local.user_data_log_stream}"
          "CPMConfigurationLogStream"     = "CPM/CPMConfigurationLog"
          "CPMRegistrationLogStream"      = "CPM/CPMRegistrationLog"
          "CPMSetLocalServiceLogStream"   = "CPM/CPMSetLocalServiceLog"
          "VaultAdminUser"                = "${var.vault_admin_username}"
          "SSMAdminPassParameterID"       = "${local.admin_password_ssm_id}"
          "VaultPrivateIP"                = "${local.vault_ips}"
          "ComponentHostname"             = "${var.instance_hostname}"
        }

        C:\CyberArk\Deployment\UserDataScript.ps1 @UserDataParams
        </powershell>
      EOF
    },
    PSM = {
      success_signal = "PSMMachine deployment process completed successfully",
      log_streams = [
        "PSM/PSMConfigurationLog",
        "PSM/PSMRegistrationLog"
      ],
      user_data = <<-EOF
        <powershell>
        $UserDataParams = @{
          "Region"                        = "${local.region}"
          "LogGroup"                      = "${var.log_group_name}"
          "UserDataLogStream"             = "${local.user_data_log_stream}"
          "PSMConfigurationLogStream"     = "PSM/PSMConfigurationLog"
          "PSMRegistrationLogStream"      = "PSM/PSMRegistrationLog"
          "VaultAdminUser"                = "${var.vault_admin_username}"
          "SSMAdminPassParameterID"       = "${local.admin_password_ssm_id}"
          "VaultPrivateIP"                = "${local.vault_ips}"
          "ComponentHostname"             = "${var.instance_hostname}"
        }

        C:\CyberArk\Deployment\UserDataScript.ps1 @UserDataParams
        </powershell>
      EOF
    },
    PSMP = {
      success_signal = "PSMPMachine deployment process completed successfully",
      log_streams = [
        "PSMP/EnvManager",
        "PSMP/PSMPHardeningLog"
      ],
      user_data = <<-EOF
        #!/bin/bash
        sudo /opt/CD-Image/register.sh \
          "aws" \
          "${local.vault_ips}" \
          "${random_string.deployment_uid.result}" \
          "ec2-user" \
          "${var.vault_admin_username}" \
          "${local.admin_password_ssm_id}" \
          "${var.instance_hostname}" \
          "${local.region}" \
          "${var.log_group_name}"
      EOF
    },
    PTA = {
      success_signal = "PTAMachine deployment process completed successfully",
      log_streams = [
        "PTA/PTAAutomaticConfigurationLog",
        "PTA/DiamondLog",
        "PTA/PrepwizLog"
      ],
      user_data = <<-EOF
        #!/bin/bash
        sudo /tmp/register.sh \
          "aws" \
          "${local.vault_ips}" \
          "${var.pvwa_private_dns}" \
          "${var.vault_admin_username}" \
          "${local.admin_password_ssm_id}" \
          "${var.instance_hostname}" \
          "${local.region}" \
          "${var.log_group_name}"
      EOF
    }
  }
}
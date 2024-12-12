# CyberArk PAMonCloud Terraform Package Release Notes
The PAMonCloud Terraform package includes CyberArk PAM product implementations, delivered as Terraform modules and examples to automate deployment on AWS and Azure. This solution provides enhanced flexibility and scalability for deploying core PAM components and associated infrastructure.

## [PAMonCloud Terraform v14.4] (12.12.2024)

### Added
- First Release of PAMonCloud over Terraform. This release of the PAMonCloud Terraform deployment tools for both AWS and Azure provides enhanced flexibility an scalability.

- Cross-region deployments.

- Support for Windows Server 2022 images across all Windows-based components.

- #### AWS
  - **New Modules**: `pam_network`, `pam_network_peering`, `component`, `vault`, `vault_dr`, `deploy_prerequisites`  
  New modules simplify the deployment of core PAM components and associated infrastructure.

  - **New Examples**: `dual-region_complete-pam`, `dual-region_vault-with-dr`, `single-region_complete-pam`, `single-region_single-component`  
  New examples demonstrate common deployment patterns for single and dual-region setups.

- #### Azure
  - **New Modules**: `pam_network`, `component`, `vault`, `vault_dr`  
  New modules simplify the deployment of core PAM components and associated infrastructure.

  - **New Examples**: `dual-region_complete-pam`, `dual-region_vault-with-dr`, `single-region_complete-pam`, `single-region_single-component`  
  New examples demonstrate common deployment patterns for single and dual-region setups.
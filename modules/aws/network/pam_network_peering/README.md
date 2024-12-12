# PAMonCloud for AWS - Network Peering Terraform Module

This module creates all necessary network resources required for the peering connection on AWS.

## Usage

See [`examples`](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/aws) directory for working examples to reference:

```hcl
module "peering_connection_request" {
  source = "../../../modules/aws/network/pam_network_peering"
  providers = {
    aws = aws.main
  }
  action              = "request"
  vpc_id              = "vpc-1234"
  vpc_cidr            = "10.0.0.0/16"
  request_peer_vpc_id = "vpc-4567"
  request_peer_region = "us-east-1"
  subnet_cidr_map = {
    "Vault Main Subnet" = "10.0.1.0/24"
    "Vault DR Subnet" = "10.0.2.0/24"
    "PVWA Main Subnet" = "10.0.3.0/24"
    "PVWA Secondary Subnet" = "10.0.4.0/24"
    "CPM Main Subnet" = "10.0.5.0/24"
    "CPM DR Subnet" = "10.0.6.0/24"
    "PSM Main Subnet" = "10.0.7.0/24"
    "PSM Secondary Subnet" = "10.0.8.0/24"
    "PSMP Main Subnet" = "10.0.9.0/24"
    "PSMP Secondary Subnet" = "10.0.10.0/24"
    "PTA Main Subnet" = "10.0.11.0/24"
    "PTA DR Subnet" = "10.0.12.0/24"
  }
  security_group_ids = {
    CPM   = "sg-06424"
    Vault = "sg-01875"
    PVWA  = "sg-01423"
    PSM   = "sg-06424"
    PSMP  = "sg-06741"
    PTA   = "sg-02987"
  }
  sg_rules = {
    Vault = {
      VaultSGIngress1 = ["ingress", 1858, 1858, "tcp", "Vault to Main Vault connection", "Vault Main Subnet"]
      VaultSGEgress2 = ["egress", 1858, 1858, "tcp", "Vault to Main PVWA connection", "PVWA Main Subnet"]
    }
    PVWA = {
      PVWASGIngress1 = ["ingress", 443, 443, "tcp", "PVWA to External Access", "0.0.0.0/0"]
      PVWASGIngress2 = ["ingress", 80, 80, "tcp", "PVWA HTTP access for testing", "0.0.0.0/0"]
      PVWASGIngress3 = ["ingress", 3389, 3389, "tcp", "Access from Administrative CIDR", "AdministrativeAccessCIDR"]
    }
  }
}

module "peering_connection_accept" {
  source = "../../../modules/aws/network/pam_network_peering"
  providers = {
    aws = aws.dr
  }
  action             = "accept"
  accept_pcx_id      = module.peering_connection_request.peering_connection_id[0]
  vpc_id             = "vpc-4567"
  vpc_cidr           = "10.1.0.0/16"
  subnet_cidr_map = {
    "Vault Main Subnet" = "10.1.1.0/24"
    "Vault DR Subnet" = "10.1.2.0/24"
    "PVWA Main Subnet" = "10.1.3.0/24"
    "PVWA Secondary Subnet" = "10.1.4.0/24"
    "CPM Main Subnet" = "10.1.5.0/24"
    "CPM DR Subnet" = "10.1.6.0/24"
    "PSM Main Subnet" = "10.1.7.0/24"
    "PSM Secondary Subnet" = "10.1.8.0/24"
    "PSMP Main Subnet" = "10.1.9.0/24"
    "PSMP Secondary Subnet" = "10.1.10.0/24"
    "PTA Main Subnet" = "10.1.11.0/24"
    "PTA DR Subnet" = "10.1.12.0/24"
  }
  security_group_ids = {
    CPM   = "sg-06584"
    Vault = "sg-01157"
    PVWA  = "sg-01458"
    PSM   = "sg-06411"
    PSMP  = "sg-12486"
    PTA   = "sg-15648"
  }
  sg_rules = {
    Vault = {
        VaultSGIngress1 = ["ingress", 1858, 1858, "tcp", "Vault to Main Vault connection", "Vault Main Subnet"]
        VaultSGEgress2 = ["egress", 1858, 1858, "tcp", "Vault to Main PVWA connection", "PVWA Main Subnet"]
    }
    PVWA = {
        PVWASGIngress1 = ["ingress", 443, 443, "tcp", "PVWA to External Access", "0.0.0.0/0"]
        PVWASGIngress2 = ["ingress", 80, 80, "tcp", "PVWA HTTP access for testing", "0.0.0.0/0"]
        PVWASGIngress3 = ["ingress", 3389, 3389, "tcp", "Access from Administrative CIDR", "AdministrativeAccessCIDR"]
    }
  }
  depends_on         = [module.peering_connection_request]
}
```

## Examples

- [dual-region_complete-pam](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/aws/dual-region_complete-pam) with PAM Network Peering.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.73.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.2 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.73.0 |

## Modules

No modules.

## Resources

### Retrieve information about a resource (post deployment)
You can use the `terraform state show` command followed by: `module.<module_name>.<resource_name>`  
Example: `terraform state show 'module.peering_connection_request.aws_route.vpc_peering_route'`  

| Name                                              | Description                                           |
|---------------------------------------------------|-------------------------------------------------------|
| `aws_route.vpc_peering_route`                     | VPC peering route                                     |
| `aws_security_group_rule.peering_rules`           | Security group rule in the peering connection module. |
| `aws_vpc_peering_connection_accepter.pcx_peer[0]` | VPC peering connection accepter                       |
| `aws_vpc_peering_connection.pcx_main[0]`          | VPC peering connection requester                      |

## Inputs

For requester:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action"></a> [action](#input\_action) | Valid option : "request" | `string` | `null` | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC Id | `string` | `null` | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC cidr | `string` | `null` | yes |
| <a name="input_request_peer_vpc_id"></a> [request\_peer\_vpc\_id](#input\_request\_peer\_vpc\_id) | VPC Id of peer | `string` | `null` | yes |
| <a name="input_request_peer_region"></a> [request\_peer\_region](#input\_request\_peer\_region) | Region of peer | `string` | `null` | yes |
| <a name="input_subnet_cidr_map"></a> [subnet\_cidr\_map](#input\_subnet\_cidr\_map) | Map of subnet names to their CIDR blocks | `map(string)` | `null` | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security groups ids | `map(string)` | `null` | yes |
| <a name="input_sg_rules"></a> [sg\_rules](#input\_sg\_rules) | Security rules for all components | `map(map(list(any)))` | `null` | yes |

For accepter :

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action"></a> [action](#input\_action) | valid option : "accept" | `string` | `null` | yes |
| <a name="input_accept_pcx_id"></a> [action](#input\_accept\_pcx\_id) | Peering connection id | `string` | `null` | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC Id | `string` | `null` | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC cidr | `string` | `null` | yes |
| <a name="input_subnet_cidr_map"></a> [subnet\_cidr\_map](#input\_subnet\_cidr\_map) | Map of subnet names to their CIDR blocks | `map(string)` | `null` | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security groups ids | `map(string)` | `null` | yes |
| <a name="input_sg_rules"></a> [sg\_rules](#input\_sg\_rules) | Security rules for all components | `map(map(list(any)))` | `null` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_peering_connection_id"></a> [peering\_connection\_id](#output\_peering\_connection\_id) | Peering connection Id |

<!-- END_TF_DOCS -->
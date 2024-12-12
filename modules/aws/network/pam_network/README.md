# PAMonCloud for AWS - Network Terraform Module

This module creates all necessary network resources required for the deployment process on AWS. It includes creating VPCs, subnets, route tables, security groups, and VPC endpoints.

## Usage

See [`examples`](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/aws) directory for working examples to reference:

```hcl
module "pam_network" {
  source = "../../../modules/aws/network/pam_network"
  providers = { //optional if deploy in dual region
    aws = aws.main
  }
  pam_vpc_cidr               = "10.0.0.0/16"
  network_type               = "nat" // or "privatelink"
  users_access_cidr          = "192.168.0.0/16"
  administrative_access_cidr = "192.168.1.0/16"
}
```

## Examples

- [single-region_complete-pam](https://github.com/cyberark/PAMonCloud-terraform/tree/master/examples/aws/single-region_complete-pam) with PAM network.

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
Example: `terraform state show 'module.pam_network.aws_network_acl.vault_nacl'`  
For list objects, you can use `terraform state list` to get all objects within the list.

| Name                                             | Description                                             |
|--------------------------------------------------|---------------------------------------------------------|
| `aws_network_acl.vault_nacl`                     | Vault network ACL.                                      |
| `aws_security_group.security_group` (list)       | List of Security groups for all instances.              |
| `aws_security_group_rule.rules_with_cidr` (list) | List of security group rules with CIDR blocks.          |
| `aws_default_network_acl.this[0]`                | Default network ACL for the VPC.                        |
| `aws_default_route_table.default[0]`             | Default route table for the VPC.                        |
| `aws_default_security_group.this[0]`             | Default security group for the VPC.                     |
| `aws_eip.nat`                                    | Elastic IP for the NAT gateway.                         |
| `aws_internet_gateway.this[0]`                   | Internet gateway for the VPC.                           |
| `aws_nat_gateway.this[0]`                        | NAT gateway for the VPC.                                |
| `aws_route.private_nat_gateway[0]`               | Route for private subnets to the NAT gateway.           |
| `aws_route.public_internet_gateway[0]`           | Route for public subnets to the internet gateway.       |
| `aws_route_table.private[0]`                     | Route table for private subnets.                        |
| `aws_route_table.public[0]`                      | Route table for public subnets.                         |
| `aws_route_table_association.private` (list)     | List of route table associations for private subnets.   |
| `aws_route_table_association.public[0]`          | Route table association for public subnets.             |
| `aws_subnet.private` (list)                      | List of private subnets.                                |
| `aws_subnet.public[0]`                           | Public subnet.                                          | 
| `aws_vpc.this[0]`                                | The VPC resource.                                       |
| `null_resource.always_recreate`                  | Triggers resource recreation.                           |
| `data.aws_availability_zones.available`          | AWS availability zones information.                     |
| `data.aws_region.current`                        | Current AWS region.                                     |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pam_vpc_cidr"></a> [pam\_vpc\_cidr](#input\_pam\_vpc\_cidr) | VPC CIDR | `string` | `null` | yes |
| <a name="input_users_access_cidr"></a> [users\_access\_cidr](#input\_users\_access\_cidr) | Allowed IPv4 address range for users access to CyberArk components. Must be a valid IP CIDR range of the form x.x.x.x/x. | `string` | `null` | yes |
| <a name="input_administrative_access_cidr"></a> [administrative\_access\_cidr](#input\_administrative\_access\_cidr) | Allowed IPv4 address range for Remote Desktop administrative access to CyberArk instances. Must be a valid IP CIDR range of the form x.x.x.x/x. | `string` | `null` | yes |
| <a name="input_network_type"></a> [network\_type](#input\_network\_type) | The type of networking to deploy. Valid options: 'privatelink' or 'nat' | `string` | `null` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public Subnet IDs |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | Public route tables IDs |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | Private route tables IDs |
| <a name="output_natgw_ids"></a> [natgw\_ids](#output\_natgw\_ids) | List of NAT Gateway IDs |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | Security Group IDs for all components |
| <a name="output_private_subnets_map"></a> [private\_subnets\_map](#output\_private\_subnets\_map) | A map of subnet details (id and cidr_block) by name |
| <a name="output_sg_rules"></a> [sg\_rules](#output\_sg\_rules) | Amazon Resource Name (ARN) of the security group |

<!-- END_TF_DOCS -->
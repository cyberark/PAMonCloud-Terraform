locals {
  network_type        = lower(var.network_type)
  public_subnet_names = (local.network_type == "nat") ? ["NAT Subnet"] : []
  public_subnets      = (local.network_type == "nat") ? [cidrsubnet(var.pam_vpc_cidr, 8, 0)] : []
  private_subnet_names = [
    "Vault Main Subnet",
    "Vault DR Subnet",
    "PVWA Main Subnet",
    "PVWA Secondary Subnet",
    "CPM Main Subnet",
    "CPM DR Subnet",
    "PSM Main Subnet",
    "PSM Secondary Subnet",
    "PSMP Main Subnet",
    "PSMP Secondary Subnet",
    "PTA Main Subnet",
    "PTA DR Subnet"
  ]
  private_subnets = [
    cidrsubnet(var.pam_vpc_cidr, 8, 1),
    cidrsubnet(var.pam_vpc_cidr, 8, 2),
    cidrsubnet(var.pam_vpc_cidr, 8, 3),
    cidrsubnet(var.pam_vpc_cidr, 8, 4),
    cidrsubnet(var.pam_vpc_cidr, 8, 5),
    cidrsubnet(var.pam_vpc_cidr, 8, 6),
    cidrsubnet(var.pam_vpc_cidr, 8, 7),
    cidrsubnet(var.pam_vpc_cidr, 8, 8),
    cidrsubnet(var.pam_vpc_cidr, 8, 9),
    cidrsubnet(var.pam_vpc_cidr, 8, 10),
    cidrsubnet(var.pam_vpc_cidr, 8, 11),
    cidrsubnet(var.pam_vpc_cidr, 8, 12)
  ]

  subnet_cidr_map = zipmap(local.private_subnet_names, local.private_subnets)
  cidr_map = {
    "UsersAccessCIDR"          = var.users_access_cidr
    "AdministrativeAccessCIDR" = var.administrative_access_cidr
  }
}

output "network_type" {
  value = local.network_type
}


data "aws_availability_zones" "available" {}

module "pam_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.15.0"

  name = "PAMonCloud VPC"
  cidr = var.pam_vpc_cidr

  azs                  = data.aws_availability_zones.available.names
  private_subnet_names = local.private_subnet_names
  private_subnets      = local.private_subnets
  public_subnet_names  = local.public_subnet_names
  public_subnets       = local.public_subnets

  create_igw           = true
  enable_nat_gateway   = local.network_type == "nat"
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true


  public_route_table_tags = {
    Name = "PAMonCloud Public Route Table"
  }

  private_route_table_tags = {
    Name = "PAMonCloud Private Route Table"
  }

  nat_eip_tags = {
    Name = "PAMonCloud NAT EIP"
  }

  nat_gateway_tags = {
    Name = "PAMonCloud NAT Gateway"
  }

  igw_tags = {
    Name = "PAMonCloud Internet Gateway"
  }
}


resource "aws_network_acl" "vault_nacl" {
  vpc_id     = module.pam_vpc.vpc_id
  subnet_ids = slice(module.pam_vpc.private_subnets, 0, 2)

  ingress {
    rule_no    = 100
    protocol   = -1
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = -1
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "PAMonCloud Vault NACL"
  }
}
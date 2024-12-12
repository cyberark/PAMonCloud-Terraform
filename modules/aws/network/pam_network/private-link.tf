data "aws_region" "current" {}

resource "aws_internet_gateway" "igw" {
  count = local.network_type == "privatelink" ? 1 : 0

  vpc_id = module.pam_vpc.vpc_id

  tags = {
    Name = "PAMonCloud Internet Gateway"
  }
}

resource "aws_route_table" "public" {
  count  = local.network_type == "privatelink" ? 1 : 0
  vpc_id = module.pam_vpc.vpc_id

  tags = {
    Name = "PAMonCloud Public Route Table"
  }
}

resource "aws_route" "public_internet_access" {
  count = local.network_type == "privatelink" ? 1 : 0

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[count.index].id
}

resource "aws_security_group" "private_link_sg" {
  count       = local.network_type == "privatelink" ? 1 : 0
  name_prefix = "PrivateLink-PAMOncloud-SG"
  description = "Security group for PAMOncloud VPC to access AWS resources by VPC Endpoint"
  vpc_id      = module.pam_vpc.vpc_id
  tags = {
    Name = "PrivateLink-PAMOncloud-SG"
  }
}

resource "aws_security_group_rule" "private_link_sg_ingress" {
  count             = local.network_type == "privatelink" ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.pam_vpc_cidr]
  security_group_id = aws_security_group.private_link_sg[count.index].id
}

resource "aws_security_group_rule" "private_link_sg_egress" {
  count             = local.network_type == "privatelink" ? 1 : 0
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private_link_sg[count.index].id
}

# S3 Gateway VPC Endpoint
resource "aws_vpc_endpoint" "vault_s3_endpoint" {
  count             = local.network_type == "privatelink" ? 1 : 0
  vpc_id            = module.pam_vpc.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [module.pam_vpc.private_route_table_ids[0]]

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:*",
      Resource  = "arn:aws:s3:::*"
    }]
  })
}

# KMS Interface VPC Endpoint
resource "aws_vpc_endpoint" "vault_kms_endpoint" {
  count               = local.network_type == "privatelink" ? 1 : 0
  vpc_id              = module.pam_vpc.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.kms"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [module.pam_vpc.private_subnets[0], module.pam_vpc.private_subnets[1]]
  security_group_ids  = [aws_security_group.private_link_sg[count.index].id]
  private_dns_enabled = true
}

# CloudFormation Interface VPC Endpoint
resource "aws_vpc_endpoint" "cfn_endpoint" {
  count               = local.network_type == "privatelink" ? 1 : 0
  vpc_id              = module.pam_vpc.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.cloudformation"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [module.pam_vpc.private_subnets[0], module.pam_vpc.private_subnets[1]]
  security_group_ids  = [aws_security_group.private_link_sg[count.index].id]
  private_dns_enabled = true
}

# SSM Interface VPC Endpoint
resource "aws_vpc_endpoint" "ssm_endpoint" {
  count               = local.network_type == "privatelink" ? 1 : 0
  vpc_id              = module.pam_vpc.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [module.pam_vpc.private_subnets[0], module.pam_vpc.private_subnets[1]]
  security_group_ids  = [aws_security_group.private_link_sg[count.index].id]
  private_dns_enabled = true
}

# CloudWatch Logs Interface VPC Endpoint
resource "aws_vpc_endpoint" "cw_endpoint" {
  count               = local.network_type == "privatelink" ? 1 : 0
  vpc_id              = module.pam_vpc.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [module.pam_vpc.private_subnets[0], module.pam_vpc.private_subnets[1]]
  security_group_ids  = [aws_security_group.private_link_sg[count.index].id]
  private_dns_enabled = true
}
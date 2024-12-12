#### IAM Policies

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "instance_ssm_managed_policy" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "instance_cloudwatch_policy" {
  name = "Instance_CloudWatch_Policy"
  role = aws_iam_role.instance_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "instance_ssm_policy" {
  name = "Instance_SSM_Policy"
  role = aws_iam_role.instance_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameters"
        ]
        Effect   = "Allow"
        Resource = "arn:${local.partition}:ssm:${local.region}:${local.account_id}:parameter/${local.admin_password_ssm_id}"
      },
    ]
  })
}

resource "aws_iam_role_policy" "instance_kms_policy" {
  name = "Instance_KMS_Policy"
  role = aws_iam_role.instance_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:CreateKey",
          "kms:GenerateRandom",
          "kms:TagResource",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:EnableKeyRotation",
          "kms:UpdateKeyDescription",
          "kms:CreateAlias"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

#### IAM Roles

resource "aws_iam_role" "instance_role" {
  name               = "PAMonCloud_TF_${var.component}_Role_${random_string.deployment_uid.result}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

#### IAM Instance Profiles

resource "aws_iam_instance_profile" "instance_profile" {
  name = "PAMonCloud_TF_${var.component}_InstanceProfile_${random_string.deployment_uid.result}"
  role = aws_iam_role.instance_role.name
}
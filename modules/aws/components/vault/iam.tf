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
        Effect = "Allow"
        Resource = [
          "arn:${local.partition}:ssm:${local.region}:${local.account_id}:parameter/${local.master_password_ssm_id}",
          "arn:${local.partition}:ssm:${local.region}:${local.account_id}:parameter/${local.admin_password_ssm_id}",
          "arn:${local.partition}:ssm:${local.region}:${local.account_id}:parameter/${local.dr_password_ssm_id}",
          "arn:${local.partition}:ssm:${local.region}:${local.account_id}:parameter/${local.dr_secret_ssm_id}"
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy" "instance_s3_policy" {
  name = "Instance_S3_Policy"
  role = aws_iam_role.instance_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]
        Effect = "Allow"
        Resource = [
          "arn:${local.partition}:s3:::${var.vault_files_bucket}/${var.license_file}",
          "arn:${local.partition}:s3:::${var.vault_files_bucket}/${var.recovery_public_key_file}"
        ]
      },
      {
        Action = [
          "s3:GetBucketLocation"
        ]
        Effect   = "Allow"
        Resource = "arn:${local.partition}:s3:::${var.vault_files_bucket}"
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

data "aws_iam_policy_document" "lambda_remove_permissions_policy" {
  statement {
    effect    = "Allow"
    actions   = ["kms:DescribeKey"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["iam:GetRole", "iam:DeleteRolePolicy", "iam:PutRolePolicy"]
    resources = [var.remove_permissions_lambda.arn, aws_iam_role.instance_role.arn]
  }
}

resource "aws_iam_role_policy" "lambda_remove_permissions_policy" {
  name   = "Lambda_RemovePermissions_Policy"
  role   = var.remove_permissions_lambda.role_name
  policy = data.aws_iam_policy_document.lambda_remove_permissions_policy.json
}

#### IAM Roles

resource "aws_iam_role" "instance_role" {
  name               = "PAMonCloud_TF_${local.component}_Role_${random_string.deployment_uid.result}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

#### IAM Instance Profiles

resource "aws_iam_instance_profile" "instance_profile" {
  name = "PAMonCloud_TF_${local.component}_InstanceProfile_${random_string.deployment_uid.result}"
  role = aws_iam_role.instance_role.name
}
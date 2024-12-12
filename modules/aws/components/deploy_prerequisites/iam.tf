#### IAM Policies

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_manage_ssm_password_execution_managed_policy" {
  role       = aws_iam_role.lambda_manage_ssm_password_role.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_retrieve_success_signal_execution_managed_policy" {
  role       = aws_iam_role.lambda_retrieve_success_signal_role.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_remove_permissions_execution_managed_policy" {
  role       = aws_iam_role.lambda_remove_permissions_role.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_manage_ssm_password_policy" {
  name = "PAMonCloud_TF_ManageSSMPassword_Policy"
  role = aws_iam_role.lambda_manage_ssm_password_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:PutParameter",
          "ssm:DeleteParameter"
        ]
        Effect   = "Allow"
        Resource = "arn:${local.partition}:ssm:${local.region}:${local.account_id}:parameter/*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_retrieve_success_signal_policy" {
  name = "PAMonCloud_TF_RetrieveSuccessSignal_Policy"
  role = aws_iam_role.lambda_retrieve_success_signal_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:FilterLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:${local.partition}:logs:${local.region}:${local.account_id}:log-group:${local.log_group_name}:*"
      },
    ]
  })
}

#### IAM Roles

resource "aws_iam_role" "lambda_manage_ssm_password_role" {
  name               = "PAMonCloud_TF_ManageSSMPassword_Role_${random_string.deployment_uid.result}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role" "lambda_retrieve_success_signal_role" {
  name               = "PAMonCloud_TF_RetrieveSuccessSignal_Role_${random_string.deployment_uid.result}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role" "lambda_remove_permissions_role" {
  name               = "PAMonCloud_TF_RemovePermissions_Role_${random_string.deployment_uid.result}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}
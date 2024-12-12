resource "aws_cloudwatch_log_group" "log_group" {
  name              = local.log_group_name
  retention_in_days = 30
}
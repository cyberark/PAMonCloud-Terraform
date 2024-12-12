#### CloudWatch Logs

resource "aws_cloudwatch_log_stream" "user_data_log_stream" {
  name           = local.user_data_log_stream
  log_group_name = var.log_group_name
  lifecycle {
    replace_triggered_by = [aws_instance.vault_dr.id]
  }
}

resource "aws_cloudwatch_log_stream" "additional_log_streams" {
  for_each       = toset(local.log_streams)
  name           = each.key
  log_group_name = var.log_group_name
  lifecycle {
    replace_triggered_by = [aws_instance.vault_dr.id]
  }
}

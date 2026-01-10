locals {
  log_group_name = "/aws/lambda/${var.name}"
}

resource "aws_cloudwatch_log_group" "logs" {
  count = var.logs.enabled ? 1 : 0

  name              = local.log_group_name
  log_group_class   = "STANDARD"
  retention_in_days = var.logs.retention_in_days
  tags              = var.tags
}

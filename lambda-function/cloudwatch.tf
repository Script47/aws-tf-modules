resource "aws_cloudwatch_log_group" "logs" {
  name              = "${var.name}-logs"
  log_group_class   = "STANDARD"
  retention_in_days = var.cloudwatch.retention_in_days
  tags              = var.tags
}
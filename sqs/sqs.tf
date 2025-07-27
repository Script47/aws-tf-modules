resource "aws_sqs_queue" "primary" {
  name                       = var.name
  max_message_size           = var.max_size_in_bytes
  message_retention_seconds  = var.retention_in_seconds
  delay_seconds              = var.initial_visibility_delay_in_seconds
  receive_wait_time_seconds  = var.poll_timeout_in_seconds
  visibility_timeout_seconds = var.lock_timeout_in_seconds
  sqs_managed_sse_enabled    = true
  tags                       = var.tags
}

resource "aws_sqs_queue" "dlq" {
  count = var.dlq.create ? 1 : 0

  name                       = "${var.name}-dlq"
  delay_seconds              = 0
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 0
  message_retention_seconds  = var.dlq.retention_in_seconds
  max_message_size           = var.max_size_in_bytes
  sqs_managed_sse_enabled    = true
  tags                       = var.tags
}

resource "aws_sqs_queue_redrive_policy" "policy" {
  count = var.dlq.create ? 1 : 0

  queue_url = aws_sqs_queue.primary.url

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.dlq.max_receive_count
  })
}

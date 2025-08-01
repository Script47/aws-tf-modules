output "arn" {
  value = aws_sqs_queue.primary.arn
}

output "name" {
  value = aws_sqs_queue.primary.name
}

output "url" {
  value = aws_sqs_queue.primary.url
}

output "dlq" {
  value = var.dlq.create ? {
    arn  = aws_sqs_queue.dlq[0].arn
    name = aws_sqs_queue.dlq[0].name
    url  = aws_sqs_queue.dlq[0].url
  } : null
}
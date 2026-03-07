output "fn" {
  value = {
    arn        = aws_lambda_function.fn.arn
    invoke_arn = aws_lambda_function.fn.invoke_arn
  }
}

output "log_group" {
  value = {
    arn = length(aws_cloudwatch_log_group.logs) > 0 ? aws_cloudwatch_log_group.logs[0].arn : null
  }
}

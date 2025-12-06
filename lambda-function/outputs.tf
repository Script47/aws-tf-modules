output "lambda" {
  value = {
    arn        = aws_lambda_function.fn.arn
    invoke_arn = aws_lambda_function.fn.invoke_arn
  }
}

output "cloudwatch" {
  value = {
    arn = aws_cloudwatch_log_group.logs.arn
  }
}
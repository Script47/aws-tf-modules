output "lambda" {
  value = {
    arn        = aws_lambda_function.lambda.arn
    invoke_arn = aws_lambda_function.lambda.invoke_arn
  }
}

output "cloudwatch" {
  value = {
    arn = aws_cloudwatch_log_group.logs.arn
  }
}
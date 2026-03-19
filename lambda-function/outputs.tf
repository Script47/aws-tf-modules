output "arn" {
  value = aws_lambda_function.this.arn
}

output "function_name" {
  value = aws_lambda_function.this.function_name
}

output "invoke_arn" {
  value = aws_lambda_function.this.invoke_arn
}

output "fn" {
  description = "Lambda function details"
  value = {
    arn        = aws_lambda_function.this.arn
    name       = aws_lambda_function.this.function_name
    invoke_arn = aws_lambda_function.this.invoke_arn
  }
}

output "log_group" {
  description = "CloudWatch log group details (if enabled)"
  value = {
    arn = try(aws_cloudwatch_log_group.this[0].arn, null)
  }
}

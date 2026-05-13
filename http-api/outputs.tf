output "apigw" {
  description = "Core HTTP API attributes"
  value = {
    id            = aws_apigatewayv2_api.this.id
    endpoint      = aws_apigatewayv2_api.this.api_endpoint
    execution_arn = aws_apigatewayv2_api.this.execution_arn
  }
}

output "log_group" {
  description = "CloudWatch log group details (if logging enabled)"
  value = {
    arn = one(aws_cloudwatch_log_group.this[*].arn)
  }
}

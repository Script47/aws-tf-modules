output "apigw" {
  value = {
    endpoint = aws_apigatewayv2_api.api.api_endpoint
  }
}

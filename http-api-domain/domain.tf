resource "aws_apigatewayv2_domain_name" "this" {
  domain_name = var.domain_name
  tags        = var.tags

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

output "domain" {
  description = "Custom domain details"
  value = {
    name           = aws_apigatewayv2_domain_name.this.domain_name
    target         = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].target_domain_name
    hosted_zone_id = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].hosted_zone_id
  }
}

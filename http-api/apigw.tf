locals {
  integrations = [
    for r in var.resources : r if r.route_key
  ]
}

resource "aws_apigatewayv2_api" "api" {
  name               = var.name
  description        = var.description
  protocol_type      = var.protocol
  ip_address_type    = "dualstack"
  cors_configuration = var.cors_config
  tags               = var.tags
}

resource "aws_apigatewayv2_route" "routes" {
  count = length(var.resources)

  api_id    = aws_apigatewayv2_api.api.id
  route_key = var.resources[count.index].route_key
}

resource "aws_apigatewayv2_integration" "integrations" {
  count = length(local.integrations)

  api_id             = aws_apigatewayv2_api.api.id
  description        = ""
  integration_type   = ""
  integration_method = ""
  integration_uri    = ""
}

# resource "aws_apigatewayv2_authorizer" "authorizer" {
#   api_id        = aws_apigatewayv2_api.api.id
#   name          = ""
#   authorizer_type = ""
#   authorizer_payload_format_version = "2.0"
# }

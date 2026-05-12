resource "aws_apigatewayv2_api" "this" {
  name                         = var.name
  description                  = var.description
  protocol_type                = "HTTP"
  disable_execute_api_endpoint = var.domain != null
  tags                         = var.tags

  dynamic "cors_configuration" {
    for_each = var.cors_config != null ? [var.cors_config] : []
    content {
      allow_credentials = cors_configuration.value.allow_credentials
      allow_headers     = cors_configuration.value.allow_headers
      allow_methods     = cors_configuration.value.allow_methods
      allow_origins     = cors_configuration.value.allow_origins
      expose_headers    = cors_configuration.value.expose_headers
      max_age           = cors_configuration.value.max_age
    }
  }
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
  tags        = var.tags

  dynamic "access_log_settings" {
    for_each = var.logs.enabled ? [1] : []
    content {
      destination_arn = aws_cloudwatch_log_group.this[0].arn
      format          = var.logs.format
    }
  }
}

resource "aws_apigatewayv2_authorizer" "this" {
  count = var.authorizer != null ? 1 : 0

  api_id                            = aws_apigatewayv2_api.this.id
  name                              = "${var.name}-authorizer"
  authorizer_type                   = "REQUEST"
  identity_sources                  = var.authorizer.identity_sources
  authorizer_uri                    = local.authorizer_uri
  authorizer_payload_format_version = var.authorizer.payload_format_version
  enable_simple_responses           = var.authorizer.enable_simple_responses
  authorizer_result_ttl_in_seconds  = var.authorizer.result_ttl_in_seconds
}

resource "aws_apigatewayv2_integration" "this" {
  for_each = var.routes

  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = local.route_integration_uris[each.key]
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "this" {
  for_each = var.routes

  api_id             = aws_apigatewayv2_api.this.id
  route_key          = each.key
  target             = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"
  authorization_type = contains(keys(local.authorized_routes), each.key) ? "CUSTOM" : "NONE"
  authorizer_id      = contains(keys(local.authorized_routes), each.key) ? aws_apigatewayv2_authorizer.this[0].id : null
}

resource "aws_lambda_permission" "authorizer" {
  count = var.authorizer != null ? 1 : 0

  statement_id  = "allow-${var.name}-apigw-authorizer"
  action        = "lambda:InvokeFunction"
  function_name = var.authorizer.function_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

resource "aws_lambda_permission" "routes" {
  for_each = var.routes

  statement_id  = "allow-apigw-${replace(each.key, "/[^a-zA-Z0-9-_]/", "-")}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

resource "aws_apigatewayv2_api_mapping" "this" {
  count = var.domain != null ? 1 : 0

  api_id          = aws_apigatewayv2_api.this.id
  domain_name     = var.domain.name
  stage           = aws_apigatewayv2_stage.this.id
  api_mapping_key = var.domain.base_path
}

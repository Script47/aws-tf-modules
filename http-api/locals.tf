locals {
  lambda_uri_prefix = "arn:aws:apigateway:${data.aws_region.current.region}:lambda:path/2015-03-31/functions"

  route_integration_uris = {
    for k, r in var.routes :
    k => "${local.lambda_uri_prefix}/${r.function_arn}/invocations"
  }

  authorizer_uri = var.authorizer != null ? "${local.lambda_uri_prefix}/${var.authorizer.function_arn}/invocations" : null

  authorized_routes = {
    for k, r in var.routes : k => r
    if r.authorized && var.authorizer != null
  }

  log_group_name = "/aws/apigateway/${var.name}"
}

variable "name" {
  type        = string
  description = "The name of the HTTP API"
}

variable "description" {
  type        = string
  description = "The description of the HTTP API"
  default     = ""
}

variable "cors_config" {
  type = object({
    allow_credentials = optional(bool, false)
    allow_headers     = optional(set(string), ["*"])
    allow_methods     = optional(set(string), ["*"])
    allow_origins     = optional(set(string), ["*"])
    expose_headers    = optional(set(string), [])
    max_age           = optional(number, 3600)
  })
  description = "Optional global CORS configuration for the API"
  default     = null
}

variable "routes" {
  type = map(object({
    function_arn = string
    authorized   = optional(bool, true)
  }))
  description = "Map of route key (e.g. \"GET /items\") to Lambda function ARN. Routes are authorized by default when an authorizer is configured; set authorized = false for public routes."
  default     = {}
}

variable "authorizer" {
  type = object({
    function_arn            = string
    identity_sources        = optional(set(string), ["$request.header.Authorization"])
    result_ttl_in_seconds   = optional(number, 300)
    payload_format_version  = optional(string, "2.0")
    enable_simple_responses = optional(bool, true)
  })
  description = "Optional REQUEST-type Lambda authorizer applied to all routes where authorized = true. The Lambda validates the JWT."
  default     = null
}

variable "domain" {
  type = object({
    name      = string
    base_path = optional(string, null)
  })
  description = "Optional base-path mapping onto an existing aws_apigatewayv2_domain_name. Create the domain with the http-api-domain module. When set, the default execute-api endpoint is disabled."
  default     = null
}

variable "logs" {
  type = object({
    enabled           = optional(bool, false)
    retention_in_days = optional(number, 30)
    format            = optional(string, "{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"requestTime\":\"$context.requestTime\",\"httpMethod\":\"$context.httpMethod\",\"routeKey\":\"$context.routeKey\",\"status\":\"$context.status\",\"responseLength\":\"$context.responseLength\",\"integrationLatency\":\"$context.integrationLatency\"}")
  })
  description = "Access log configuration for the default stage"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
  default     = {}
}

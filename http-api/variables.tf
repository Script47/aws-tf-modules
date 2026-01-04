variable "name" {
  type        = string
  description = "The name of the API"
}

variable "description" {
  type        = string
  description = "The description of the API"
}

variable "protocol" {
  type    = string
  default = "HTTP"
  validation {
    condition     = contains(["HTTP"], var.protocol)
    error_message = "protocol must be either \"HTTP\""
  }
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
  description = "The global CORS config for the API"
  default     = null
}

variable "authorizer" {
  type = object({
    type                  = optional(string, "REQUEST")
    uri                   = optional(string, null)
    identity_sources      = set(string)
    result_ttl_in_seconds = optional(number, 300)
  })
}

variable "resources" {
  type = map(object({
    route_key = string
  }))
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
}

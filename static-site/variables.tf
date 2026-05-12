variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket. If create_bucket is false, this must refer to an existing bucket. If omitted, the bucket name will match the domain name"
  default     = ""
}

variable "hosted_zone" {
  type        = string
  description = "The name of the hosted zone. If omitted, a hosted zone based on the domain name will be created"
  default     = ""
}

variable "domains" {
  type        = list(string)
  description = "List of domain names for your CloudFront distribution. The first domain specified will be classed as the primary domain (used as S3 bucket name, Route53 hosted zone name etc.)"

  validation {
    condition     = length(var.domains) > 0
    error_message = "domains requires at least one domain to be specified"
  }
}

variable "geo_restriction" {
  type = object({
    type      = optional(string, "none")
    locations = optional(list(string), [])
  })
  default = {
    type      = "none"
    locations = []
  }
  description = "GEO restriction configuration for the CloudFront distribution"
}

variable "viewer_certificate" {
  type = object({
    minimum_protocol_version = optional(string, "TLSv1.2_2025")
  })
  default = {
    minimum_protocol_version = "TLSv1.2_2025"
  }
  description = "Viewer certificate configuration for the CloudFront distribution"
}

variable "cors_config" {
  description = "Optional CORS configuration for CloudFront response headers policy"
  type = object({
    access_control_allow_credentials = optional(bool, false)
    access_control_allow_headers     = optional(list(string), ["*"])
    access_control_allow_methods     = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    access_control_allow_origins     = optional(list(string), ["*"])
    origin_override                  = optional(bool, true)
  })
  default = {}
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
}

variable "origin_path" {
  type        = string
  description = "Optional prefix inside the S3 bucket for static site files"
  default     = ""
}

variable "create_bucket" {
  description = "Whether to create a new S3 bucket or use an existing one"
  type        = bool
  default     = true
}
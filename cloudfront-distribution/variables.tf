variable "hosted_zone" {
  type        = string
  description = "The name of the hosted zone."
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
  default = {}
  description = "GEO restriction configuration for the CloudFront distribution"
}

variable "viewer_certificate" {
  type = object({
    minimum_protocol_version = optional(string, "TLSv1.2_2025")
  })
  default = {}
  description = "Viewer certificate configuration for the CloudFront distribution"
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
}

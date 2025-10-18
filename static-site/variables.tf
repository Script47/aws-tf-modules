variable "bucket_name" {
  type        = string
  description = "The name of the bucket that will store your static site files. If omitted the bucket name will match the domain name"
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

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
}

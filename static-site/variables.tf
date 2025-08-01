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

variable "cloudfront" {
  type = object({
    restriction = optional(object({
      type      = string
      locations = list(string)
      }),
      {
        type      = "none"
        locations = []
    })

    viewer_certificate = optional(object({
      minimum_protocol_version = string
      }),
      {
        minimum_protocol_version = "TLSv1.2_2021"
    })
  })
  default = {
    restriction = {
      type      = "none"
      locations = []
    }
    viewer_certificate = {
      minimum_protocol_version = "TLSv1.2_2021"
    }
  }
  description = "Additional configuration options for the CloudFront distribution"
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
}

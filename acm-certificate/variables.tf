variable "zone_id" {
  type        = string
  description = "The ID of the hosted zone"
  default     = null
}

variable "domains" {
  type        = list(string)
  description = "List of domain names for your CloudFront distribution. The first domain specified will be classed as the primary domain (used as S3 bucket name, Route53 hosted zone name etc.)"

  validation {
    condition     = length(var.domains) > 0
    error_message = "domains requires at least one domain to be specified"
  }
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
}

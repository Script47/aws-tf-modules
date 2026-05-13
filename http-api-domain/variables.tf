variable "domain_name" {
  type        = string
  description = "The custom domain name (e.g. api.mysite.com)"
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate for this domain (must be in the same region as the API)"
}

variable "zone_id" {
  type        = string
  description = "Route53 hosted zone ID. If provided, an A record alias will be created automatically"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
  default     = {}
}

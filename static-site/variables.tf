variable "bucket_name" {
  type        = string
  description = "The name of the bucket which will hold your static site"
}

variable "hosted_zone_id" {
  type        = string
  description = "The hosted zone ID to attach the A record for your custom domain"
}

variable "domain_name" {
  type        = string
  description = "The custom domain for your CloudFront distribution"
}

variable "minimum_protocol_version" {
  type        = string
  description = "Set the minimum viewer certificate version for the CloudFront distribution"
  default     = "TLSv1.2_2021"
}

variable "role_name" {
  type        = string
  description = "The name of the role and policy with the ability to deploy"
  default     = "deploy-static-site"
}

variable "restriction_type" {
  type        = string
  description = "The restriction type for the CloudFront distribution"
  default     = "none"
}

variable "locations" {
  type        = list(string)
  description = "The locations for the restriction type"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
}

variable "repo_path" {
  type = string
  description = "The repo path for the project"
}
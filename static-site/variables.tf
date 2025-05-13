variable "bucket_name" {
  type        = string
  description = "The name of the bucket that will store your static site files"
}

variable "hosted_zone" {
  type        = string
  description = "The name of the hosted zone. If omitted, a hosted zone based on the domain name will be created"
  default     = ""
}

variable "domain_name" {
  type        = string
  description = "The custom domain name for your CloudFront distribution"
}

variable "role_name" {
  type        = string
  description = "The name of the role and policy that will enable deployment through pipelines"
  default     = "deploy-static-site"
}

variable "repo" {
  type        = string
  description = "The repo path for your project"
}

variable "cloudfront" {
  type = object({
    restriction = optional(object({
      type = string
      locations = list(string)
    }),
      {
        type = "none"
        locations = []
      })

    viewer_certificate = optional(object({
      minimum_protocol_version = string
    }),
      {
        minimum_protocol_version = "TLSv1.2_2021"
      })
  })
  description = "Additional configuration options for the CloudFront distribution"
}

variable "setup_cd" {
  type        = bool
  description = "Whether to create OIDC/IAM roles/policies needed to deploy via GitHub Actions"
  default     = true
}

variable "tags" {
  type = map(string)
  description = "The tags to apply to all resources created"
}

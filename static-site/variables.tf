variable "bucket_name" {
  type        = string
  description = "The name of the bucket which will hold your static site"
}

variable "domain_name" {
  type        = string
  description = "The custom domain for your CloudFront distribution"
}

variable "role_name" {
  type        = string
  description = "The name of the role and policy with the ability to deploy"
  default     = "deploy-static-site"
}

variable "repo" {
  type        = string
  description = "The repo path for the project"
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
  description = "The configuration for the CloudFront distribution"
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
}

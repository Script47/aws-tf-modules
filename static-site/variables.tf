variable "bucket_name" {
  type        = string
  description = "The name of the bucket that will store your static site files. If omitted the bucket name will match the domain name"
  default = ""
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
  validation {
    condition     = !(var.setup_cd && (var.role_name == null || var.role_name == ""))
    error_message = "role_name must be set if CD is being setup"
  }
}

variable "repo" {
  type        = string
  description = "The repo path for your project"
  default     = null
  validation {
    condition     = !(var.setup_cd && (var.repo == null || var.repo == ""))
    error_message = "repo must be set if CD is being setup"
  }
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
  default = {
    restriction = {
      type = "none"
      locations = []
    }
    viewer_certificate = {
      minimum_protocol_version = "TLSv1.2_2021"
    }
  }
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

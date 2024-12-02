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
  type = string
  description = "The repo path for the project"
}

variable "cloudfront" {
  type = object({
    aliases = list(string)

    restriction = object({
      type = string
      locations = list(string)
    })

    viewer_certificate = object({
      minimum_protocol_version = string
    })
  })

  default = {
    aliases = [var.domain_name]

    restriction = {
      type = "none"
      locations = []
    }

    viewer_certificate = {
      minimum_protocol_version = "TLSv1.2_2021"
    }
  }
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
}

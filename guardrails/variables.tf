variable "ebs" {
  description = "EBS account-level config"
  type = object({
    encrypted = optional(bool, true)
  })
  default = {}
}

variable "s3" {
  description = "S3 account-level config"
  type = object({
    public_access_block = optional(object({
      enabled                 = optional(bool, true)
      block_public_acls       = optional(bool, true)
      block_public_policy     = optional(bool, true)
      ignore_public_acls      = optional(bool, true)
      restrict_public_buckets = optional(bool, true)      
    }), {})
  })
  default = {}
}

variable "iam" {
  description = "IAM account-level config"
  type = object({
    password_policy = optional(object({
      enabled                        = optional(bool, true)
      allow_users_to_change_password = optional(bool, true)
      password_reuse_prevention      = optional(number, 0)
      hard_expiry                    = optional(bool, false)
      max_password_age               = optional(number, null)
      minimum_password_length        = optional(number, 12)

      require_lowercase_characters   = optional(bool, true)
      require_uppercase_characters   = optional(bool, true)
      require_numbers                = optional(bool, true)
      require_symbols                = optional(bool, true)
    }), {})
  })
  default = {}
}

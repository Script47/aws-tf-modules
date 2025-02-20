variable "ebs" {
  type = object({
    encrypted = optional(bool, true)
  })
  default = {}
}

variable "s3" {
  type = object({
    block_public_acls       = optional(bool, true)
    block_public_policy     = optional(bool, true)
    ignore_public_acls      = optional(bool, true)
    restrict_public_buckets = optional(bool, true)
  })
  default = {}
}

# variable "iam" {
#   type = object({
#      password_policy = optional(object({
#         allow_password_change = optional(bool, true)
          # reuse_prevention = optional(bool, true)
#         hard_expiry = optional(bool, false)
#         max_password_age = optional(number, null)
          # min_length = optional(number, 8)

#      }), {}) 
#   })
# }
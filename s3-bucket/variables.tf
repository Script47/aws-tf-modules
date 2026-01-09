variable "name" {
  type        = string
  description = "The name of the bucket"
  default     = null
}

variable "policy" {
  type        = string
  description = ""
  default     = null
}

variable "versioned" {
  type        = bool
  description = "Enable bucket versioning"
  default     = false
}

variable "sse" {
  type = object({
    enabled            = optional(bool, true)
    enforced           = optional(bool, true)
    algo               = optional(string, "AES256")
    kms_key_id         = optional(string, null)
    bucket_key_enabled = optional(bool, null)
  })
  default = {}
}

variable "public_access_block" {
  type = object({
    block_public_acls       = optional(bool, true)
    block_public_policy     = optional(bool, true)
    ignore_public_acls      = optional(bool, true)
    restrict_public_buckets = optional(bool, true)
  })
  default = {}
}

# variable "lifecycle_rules" {
#   type = list(object({
#     id              = string
#     enabled         = bool
#     expiration_days = optional(number)
#     filter = optional(list(object({
#       prefix = optional(string, "")

#     })))
#     transitions     = optional(list(object({
#       days          = optional(number, 0)
#       storage_class = string
#     })))
#   }))
#   default = []
# }

variable "eventbridge" {
  type        = bool
  description = "Enable EventBridge events against this bucket"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
}

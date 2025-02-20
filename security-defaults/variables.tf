variable "ebs" {
  type = object(optional({
    encryption_by_default = bool
    }, {
    encryption_by_default = true
  }))
}

variable "s3" {
  type = object(optional({
    account_public_access_block = {
      block_public_acls       = bool
      block_public_policy     = bool
      ignore_public_acls      = bool
      restrict_public_buckets = bool
    }
    }, {
    account_public_access_block = {
      block_public_acls       = false
      block_public_policy     = false
      ignore_public_acls      = false
      restrict_public_buckets = false
    }
  }))
}
variable "zone_id" {
  type        = string
  description = "The ID of the hosted zone"
  default     = null

  validation {
    condition     = !var.manage_dns_records || var.zone_id != null
    error_message = "zone_id must be provided when manage_dns_records is true."
  }
}

variable "manage_dns_records" {
  type        = bool
  description = "Whether to create Route53 DNS records in the provided zone. Set to false to create the SES domain identity without managing DNS."
  default     = true
}

variable "domain" {
  type        = string
  description = "The domain name"
}

variable "domain_verification" {
  type = object({
    ttl = optional(number, 600)
  })
  default = {}
}

variable "dkim" {
  type = object({
    enabled = optional(bool, true)
    ttl     = optional(number, 600)
  })
  default = {}
}

variable "spf" {
  type = object({
    enabled  = optional(bool, false)
    includes = optional(list(string), ["amazonses.com"])
    all      = optional(string, "~all")
    ttl      = optional(number, 600)
  })
  default = {}

  validation {
    condition     = contains(["~all", "-all"], var.spf.all)
    error_message = "spf.all must be one of ~all or -all."
  }
}

variable "dmarc" {
  type = object({
    enabled = optional(bool, false)
    policy  = optional(string, "v=DMARC1; p=reject;")
    ttl     = optional(number, 600)
  })
  default = {}
}

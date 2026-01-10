variable "hosted_zone" {
  type        = string
  description = "The name of the hosted zone"
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
    ttl = optional(number, 600)
  })
  default = {}
}

variable "dmarc" {
  type = object({
    enabled = optional(bool, false)
    policy  = optional(string, "v=DMARC1; p=reject;")
    ttl = optional(number, 600)
  })
  default = {}
}

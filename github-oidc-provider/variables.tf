variable "thumbprints" {
  type        = list(string)
  description = "An optional thumbprint list."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
  default     = {}
}

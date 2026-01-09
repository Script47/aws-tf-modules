variable "name" {
  type        = string
  description = "The name of the bucket."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
}

variable "role_name" {
  type        = string
  description = "The IAM role name"
  default     = null
}

variable "policy_name" {
  type        = string
  description = "The IAM role policy name"
  default     = null
}

variable "policy" {
  type        = string
  description = "The IAM role policy in JSON format"
}

variable "repo" {
  type        = string
  description = "The GitHub repository path (e.g. org/repo:ref:refs/heads/master)"
}

variable "tags" {
  type = map(string)
  description = "The tags to apply to all resources created"
  default = {}
}
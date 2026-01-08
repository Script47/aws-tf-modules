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
  default     = null
}

variable "policy_arns" {
  type        = set(string)
  description = "Set of IAM policy ARNs to attach to the role"
  default     = [] 
}

variable "sub" {
  type        = string
  description = "The sub pattern for the assume role policy (e.g. org/repo:ref:refs/heads/master)"
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
  default     = {}
}
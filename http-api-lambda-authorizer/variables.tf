variable "name" {
  type        = string
  description = "The function's name"
}

variable "description" {
  type        = string
  default     = ""
  description = "The function's description"
}

variable "create_role" {
  type        = bool
  default     = true
  description = "Whether the module should create its own execution role. Forwards to the inner lambda-function module."
}

variable "role_arn" {
  type        = string
  description = "ARN of the role assumed by the function. If unspecified a role will be created"
  default     = null
}

variable "policy_arns" {
  type        = list(string)
  description = "Optional list of policy ARNs to attach to the execution role"
  default     = []
}

variable "inline_policies" {
  type        = map(any)
  description = "Map of inline IAM policy documents"
  default     = {}
}

variable "layer_arns" {
  type        = list(string)
  default     = []
  description = "ARNs of Lambda layers to attach"
}

variable "runtime" {
  type        = string
  default     = "nodejs24.x"
  description = "Lambda runtime environment identifier"
}

variable "architectures" {
  type        = set(string)
  default     = ["arm64"]
  description = "A list of the supported architectures"
}

variable "memory" {
  type        = number
  default     = 128
  description = "Allocated memory for the function"
}

variable "timeout" {
  type        = number
  default     = 3
  description = "Lambda execution timeout in seconds"
}

variable "concurrency" {
  type        = number
  default     = -1
  description = "Set the maximum execution concurrency"
}

variable "vars" {
  type        = map(string)
  default     = {}
  description = "Environment variables available to the function"
}

variable "src" {
  type        = string
  description = "The path to your function code"
}

variable "handler" {
  type        = string
  description = "The function's entrypoint"
}

variable "logs" {
  type = object({
    enabled           = optional(bool, true)
    format            = optional(string, "Text")
    retention_in_days = optional(number, 30)
    app_log_level     = optional(string, null)
    system_log_level  = optional(string, null)
  })
  default = {}
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
  default     = {}
}

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
  description = "Whether the module should create its own execution role. Set to false when passing a pre-created role via `role_arn` (e.g. shared roles consolidated at the consumer's root level)."
}

# `role_arn` already exists; tighten its description:
variable "role_arn" {
  type        = string
  default     = null
  description = "Pre-created IAM role ARN. Only read when `create_role = false`. The arn may be a not-yet-computed reference (e.g. `aws_iam_role.shared.arn`), the module reads it only inside the `count = 0` branch so plan-time evaluation works."
}

variable "policy_arns" {
  type        = list(string)
  description = "Option list of policy ARNs to attach to the execution role"
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
  description = "ARN of layers"
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
    format            = optional(string, "Text") # Text, JSON
    retention_in_days = optional(number, 30)
    app_log_level     = optional(string, null) # TRACE, DEBUG, INFO, WARN, ERROR, FATAL
    system_log_level  = optional(string, null) # DEBUG, INFO, WARN
  })
  default = {}
}

variable "permissions" {
  type = map(object({
    action     = string
    principal  = string
    source_arn = optional(string, null)
  }))
  default = {}
}

variable "async_invoke_config" {
  type = object({
    enabled                 = optional(bool, false)
    max_retries             = optional(number, 2)
    max_event_age           = optional(number, 3600) # 1 hour
    failure_destination_arn = optional(string, null)
    success_destination_arn = optional(string, null)
  })
  default = {}
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
  default     = {}
}

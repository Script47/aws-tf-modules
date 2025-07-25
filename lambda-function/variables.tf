variable "name" {
  type        = string
  description = "The function's name"
}

variable "description" {
  type        = string
  description = "The function's description"
  default     = ""
}

variable "role_arn" {
  type        = string
  description = "ARN of the role assumed by the function"
}

variable "runtime" {
  type        = string
  description = "Lambda runtime environment identifier"
  default     = "nodejs22.x"
}

variable "architectures" {
  type = list(string)
  description = "A list of the supported architectures"
  default = ["arm64"]
}

variable "memory" {
  type        = number
  description = "Allocated memory for the function"
  default     = 128
}

variable "timeout" {
  type        = number
  description = "Lambda execution timeout in seconds"
  default     = 3
}

variable "concurrency" {
  type        = number
  description = "Set the maximum execution concurrency"
  default     = -1
}

variable "layer_arns" {
  type = list(string)
  description = "ARN of layers"
  default = []
}

variable "handler" {
  type        = string
  description = "The function's entrypoint"
}

variable "vars" {
  type = map(string)
  description = "Environment variables available to the function"
  default = {}
}

variable "cloudwatch" {
  type = object({
    app_log_level = optional(string, "INFO") # TRACE, DEBUG, INFO, WARN, ERROR, FATAL
    system_log_level = optional(string, "INFO") # DEBUG, INFO, WARN
    retention_in_days = optional(number, 30)
  })
  default = {}
}

variable "src" {
  type        = string
  description = "The path to your function code"
}

variable "async_invoke_config" {
  type = object({
    max_retries = optional(number, 2)
    max_event_age = optional(number, 21600) # 6 hours
    failure_destination_arn = optional(string, null)
    success_destination_arn = optional(string, null)
  })
  default = {}
}

variable "permissions" {
  type = map(object({
    principal = string
    action    = string
    source_arn = optional(string, null)
  }))
  default = {}
}

variable "tags" {
  type = map(string)
  description = "The tags to apply to all resources created"
  default = {}
}

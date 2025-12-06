variable "name" {
  type        = string
  description = "The function's name"
}

variable "description" {
  type        = string
  default     = ""
  description = "The function's description"
}

variable "role_arn" {
  type        = string
  description = "ARN of the role assumed by the function"
}

variable "runtime" {
  type        = string
  default     = "nodejs24.x"
  description = "Lambda runtime environment identifier"
}

variable "architectures" {
  type        = list(string)
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

variable "layer_arns" {
  type        = list(string)
  default     = []
  description = "ARN of layers"
}

variable "handler" {
  type        = string
  description = "The function's entrypoint"
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

variable "logs" {
  type = object({
    app_log_level     = optional(string, "INFO") # TRACE, DEBUG, INFO, WARN, ERROR, FATAL
    system_log_level  = optional(string, "INFO") # DEBUG, INFO, WARN
    retention_in_days = optional(number, 30)
  })
  default = {}
}

variable "async_invoke_config" {
  type = object({
    max_retries             = optional(number, 2)
    max_event_age           = optional(number, 3600) # 1 hour
    failure_destination_arn = optional(string, null)
    success_destination_arn = optional(string, null)
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

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources created"
  default     = {}
}

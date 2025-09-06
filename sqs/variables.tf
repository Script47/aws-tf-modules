variable "name" {
  type = string
  description = "The name of your queue"
}

variable "max_size_in_bytes" {
  type    = number
  default = 262144
  description = "Defaults to 256 KiB"
}

variable "retention_in_seconds" {
  type    = number
  default = 604800
  description = "Duration a message is kept in the queue. Defaults to 7 days"
}

# delay_seconds
variable "initial_visibility_delay_in_seconds" {
  type    = number
  default = 0
  description = "Duration a message is initially hidden before becoming visible in the queue"
}

# receive_wait_time_seconds
variable "poll_timeout_in_seconds" {
  type        = number
  default     = 0
  description = "Duration the consumer waits when polling the queue before timing out"
}

# visibility_timeout_seconds
variable "lock_timeout_in_seconds" {
  type    = number
  default = 30
  description = "Duration an in-flight message is hidden from other consumers after being consumed"
}

variable "dlq" {
  type = object({
    create = optional(bool, false)
    max_receive_count = optional(number, 3)
    retention_in_seconds = optional(number, 1209600)
  })
  default = {}
  description = "DLQ configuration for your queue"
}


variable "tags" {
  type = map(string)
  default = {}
  description = "The tags to apply to all resources created"
}

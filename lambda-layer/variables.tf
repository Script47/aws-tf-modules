variable "name" {
  type        = string
  description = "The name of the layer"
}

variable "description" {
  type        = string
  description = "The description of the layer"
  default     = ""
}

variable "architectures" {
  type = list(string)
  description = "The compatible architectures"
  default = ["arm64"]
}

variable "runtimes" {
  type = list(string)
  description = "The compatible runtimes"
  default = ["nodejs22.x"]
}

variable "src" {
  type        = string
  description = "The src path for the layer"
}

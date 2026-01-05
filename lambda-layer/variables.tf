variable "name" {
  type        = string
  description = "The name of the layer"
}

variable "description" {
  type        = string
  default     = ""
  description = "The description of the layer"
}

variable "runtimes" {
  type = list(string)
  default = ["nodejs24.x"]
  description = "The compatible runtimes"
}

variable "architectures" {
  type = list(string)
  default = ["arm64"]
  description = "The compatible architectures"
}

variable "src" {
  type        = string
  description = "The src path for the layer"
}

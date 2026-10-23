variable "name" {
  type        = string
  description = "Service name, used as the file name"
}


variable port {
  type        = number
  description = "Service port, used in the file content"
}

variable public {
  type        = bool
  description = "Whether the service is public or private, used in the file content"
  default     = false
}
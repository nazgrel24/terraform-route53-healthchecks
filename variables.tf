variable "protocol" {
  description     = "Protocol for the health check."
  type            = string
  default         = "TCP"
  validation {
    condition     = contains(["TCP", "HTTP", "HTTPS"], var.protocol)
    error_message = "Protocol must be one of TCP, HTTP, or HTTPS."
  }
}

variable "resource_ip_address" {
  description = "IP address or Domain name of the resource."
  type        = string
}

variable "port" {
  description = "Port number of the resource."
  type        = number
}

variable "path" {
  description = "Path (optional). Used only with HTTP and HTTPS health checks."
  type        = string
  default     = ""
}

variable "subnets" {
  description = "List of private subnet IDs with access to the internet and the monitored resource."
  type        = list(string)
}

variable "vpc" {
  description = "VPC ID containing the Lambda subnets."
  type        = string
}

variable "region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

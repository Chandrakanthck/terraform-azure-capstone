variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
}

variable "db_host" {
  description = "Database host (private IP)"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}


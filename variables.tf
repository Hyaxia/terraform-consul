variable "kube_config_path" {
  description = "Kubernetes config path"
  type        = string
  default     = "~/.kube/config"
}
variable "webapp_port" {
  description = "Webapp - listerning port"
  type        = number
  default     = 8080
}

variable "webapp_replicas" {
  description = "Webapp - number of replicas"
  type        = number
  default     = 3
}

variable "gateway_port" {
  description = "Gateway - number of replicas"
  type        = number
  default     = 5000
}

variable "gateway_replicas" {
  description = "Gateway - number of replicas"
  type        = number
  default     = 3
}


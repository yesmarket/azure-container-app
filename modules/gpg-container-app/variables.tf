variable "naming_prefix" {
  type        = string
  description = "The naming prefix for all resource in this module."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group that will contain the container-app (and related resources)."
}

variable "location" {
  type        = string
  description = "The location of the container-app."
}

variable "tenant_id" {
  type        = string
  description = "AAD tennant ID."
}

variable "virtual_network_id" {
  type        = string
  description = "The virtual networks that will be linked to a private DNS zone that contains DNS records to resolve to container app environment."
}

variable "infrastructure_subnet_id" {
  type        = string
  description = "The subnet to associate with the container app environment."
}

variable "acr_server" {
  type        = string
  description = "The ACR server."
}

variable "acr_username" {
  type        = string
  description = "The ACR username."
}

variable "acr_password" {
  type        = string
  description = "The ACR password."
  sensitive   = true
}

variable "image_name" {
  type        = string
  description = "The name of the container image."
}

variable "cpu" {
  type        = number
  description = "The required number of CPU cores of the container."
  default     = 0.25
}

variable "memory" {
  type        = string
  description = "The required memory of the container in GB."
  default     = "0.5Gi"
}

variable "allow_insecure_connections" {
  type        = bool
  description = "Should this ingress allow insecure connections?"
  default     = false
}

variable "is_internal" {
  type        = bool
  description = "Are connections to this Ingress from outside the Container App Environment enabled?"
  default     = true
}

variable "target_port" {
  type        = number
  description = "The target port on the container for the Ingress traffic."
}

#variable "exposed_port" {
#  type        = number
#  description = "The exposed port on the container for the Ingress traffic."
#}

variable "max_replicas" {
  type        = number
  description = "The maximum number of replicas for this container."
  default     = 1
}

variable "min_replicas" {
  type        = number
  description = "The minimum number of replicas for this container."
  default     = 1
}

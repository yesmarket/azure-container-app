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

variable "subnet_id" {
  type        = string
  description = "The subnet to associate with the container group."
}

variable "auth_key" {
  type        = string
  description = "The ADF SHIR auth key."
}

variable "acr_server" {
  type        = string
  description = "The ACR server."
}

variable "acr_username" {
  type        = string
  description = "The ACR username."
  default     = "ryanbartsch"
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
  type        = string
  description = "The required number of CPU cores of the container."
  default     = "1"
}

variable "memory" {
  type        = string
  description = "The required memory of the container in GB."
  default     = "3"
}

variable "port" {
  type        = number
  description = "The port number the container will expose."
  default     = 80
}


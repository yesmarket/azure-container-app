variable "naming_prefix" {
  type        = string
  description = "The naming prefix for all resource in this module."	
}

variable "resource_group_name" {
  type        = string
  description = "The resource group that will contain the ADF workspace (and related resources)."
}

variable "location" {
  type        = string
  description = "The location of the ADF workspace."
}

variable "naming_prefix" {
  type        = string
  description = "The naming prefix for all resource in this module."	
}

variable "resource_group_name" {
  type        = string
  description = "The resource group that will contain the storage account (and related resources)."
}

variable "location" {
  type        = string
  description = "The location of the storage account."
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "The subnet where the storage account private endpoint will be deployed."
}

variable "private_dns_zone_virtual_networks" {
  type        = map(any)
  description = "The virtual networks that will be linked to the private DNS zone that contains DNS records to resolve the storage account private endpoint IP address. Note: this is a map, because we might want this DNS config in multiple peered networks."
}

variable "sftp_enabled" {
  type        = bool
  description = ""
  default 	  = false
}

variable "hierarchical_namespace_enabled" {
  type        = bool
  description = ""
  default 	  = false
}

variable "account_tier" {
  type        = string
  description = ""
  default 	  = "Standard"
}

variable "account_kind" {
  type        = string
  description = ""
  default 	  = "StorageV2"
}

variable "account_replication_type" {
  type        = string
  description = ""
  default 	  = "LRS"
}

variable "sftp_container_name" {
  type        = string
  description = ""
  default 	  = "sftp"
}

variable "username" {
  type        = string
  description = "The SSH username for accessing VMs."
  default     = "ryanbartsch"
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH public key for accessing VMs."
  default 	  = null
}

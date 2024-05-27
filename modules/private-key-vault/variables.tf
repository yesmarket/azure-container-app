variable "naming_prefix" {
  type        = string
  description = "The naming prefix for all resource in this module."  
}

variable "resource_group_name" {
  type        = string
  description = "The resource group that will contain the subnet-router (and related resources)."
}

variable "location" {
  type        = string
  description = "The location of the subnet-router."
}

variable "tenant_id" {
  type        = string
  description = "Entra tenant ID."
}

variable "key_vault_full_access_users" {
  type        = map(string)
  description = "AAD security principals (object IDs) with full access to key vault secrets"
}

variable "key_vault_readers" {
  type        = map(string)
  description = "AAD security principals (object IDs) with reader permissions to key vault secrets"
}

variable "key_vault_secrets" {
  type        = map(string)
  description = "Azure Key Vault secrets."
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "The subnet where the storage account private endpoint will be deployed."
}

variable "private_dns_zone_virtual_networks" {
  type        = map(any)
  description = "The virtual networks that will be linked to the private DNS zone that contains DNS records to resolve the storage account private endpoint IP address. Note: this is a map, because we might want this DNS config in multiple peered networks."
}

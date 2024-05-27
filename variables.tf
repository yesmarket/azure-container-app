variable "tenant_id" {
  type        = string
  description = "AAD tennant ID."
}

variable "client_id" {
  type        = string
  description = "Azure service principal client ID."
}

variable "client_secret" {
  type        = string
  description = "Azure service principal client secret."
  sensitive   = true
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
}

variable "location" {
  type        = string
  description = "Azure subscription ID."
  default     = "Australia East"
}

variable "username" {
  type        = string
  description = "The SSH username for accessing VMs."
  default     = "ryanbartsch"
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH public key for accessing VMs."
}

variable "password" {
  type        = string
  description = "The password for SQL auth to the Azure SQL Database."
  sensitive   = true
}

variable "tailscale_subnet_router_auth_key" {
  type        = string
  description = "Used to authenticate subnet-router VMs without an interactive login."
  sensitive   = true
}

variable "tailscale_subnet_routers" {
  type        = list(any)
  description = "A list of subnet-routers to deploy. Multiple items represents a HA subnet-router configuraiton."
  default     = ["primary"]
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR range for the network VNET."
  default     = "10.0.0.0/22"
}

variable "key_vault_full_access_users" {
  type        = map(string)
  description = "AAD security principals (object IDs) with full access to key vault secrets"
}

variable "key_vault_secrets" {
  type        = map(string)
  description = "Azure Key Vault secrets."
}

variable "add_private_storage_account" {
  type        = bool
  description = "Determines whether to create a private storage account or not."
  default     = true
}

variable "add_private_key_vault" {
  type        = bool
  description = "Determines whether to create a private key vault or not."
  default     = true
}

variable "add_gpg_function_app" {
  type        = bool
  description = "Determines whether to create a GPG function app or not."
  default     = true
}

variable "add_gpg_container_app" {
  type        = bool
  description = "Determines whether to create a GPG container app or not."
  default     = true
}

variable "add_adf_workspace" {
  type        = bool
  description = "determines whether to create an ADF workspace or not."
  default     = true
}

variable "add_adf_self_hosted_ir" {
  type        = bool
  description = "determines whether to register a self hoster IR in ADF."
  default     = true
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

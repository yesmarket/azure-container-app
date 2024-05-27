# RGs
resource "azurerm_resource_group" "this" {
  name     = "${local.naming_prefix}-rg"
  location = var.location
}

# VNETs
resource "azurerm_virtual_network" "this" {
  name                = "${local.naming_prefix}-vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = [var.vnet_cidr]
}

# subnets
resource "azurerm_subnet" "public" {
  name                 = "${local.naming_prefix}-public-snet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 4, 0)]
}

resource "azurerm_subnet" "private" {
  name                 = "${local.naming_prefix}-private-snet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 4, 1)]
}

resource "azurerm_subnet" "ci" {
  name                 = "${local.naming_prefix}-ci-snet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 4, 2)]

  delegation {
    name = "ci"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "cae" {
  name                 = "${local.naming_prefix}-cae-snet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 1, 1)]

  delegation {
    name = "cae"

    service_delegation {
      name = "Microsoft.App/environments"
    }
  }
}

module "natg" {
  source              = "./modules/nat-gateway"
  naming_prefix       = local.naming_prefix
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.public.id
}

# subnet-router
resource "azurerm_availability_set" "tailscale_subnet_router_aset" {
  count                       = length(var.tailscale_subnet_routers) > 0 ? 1 : 0
  name                        = "${local.naming_prefix}-tailscale-subnet-router-aset"
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  platform_fault_domain_count = 2
}
module "tailscale_subnet_router" {
  for_each            = toset(var.tailscale_subnet_routers)
  source              = "./modules/tailscale-subnet-router"
  naming_prefix       = local.naming_prefix
  unique_identifier   = each.key
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.private.id
  username            = var.username
  ssh_public_key      = var.ssh_public_key
  auth_key            = var.tailscale_subnet_router_auth_key
  advertised_routes   = var.vnet_cidr
  availability_set_id = azurerm_availability_set.tailscale_subnet_router_aset.0.id
}

# private storage account
module "private_storage_account" {
  count                      = var.add_private_storage_account ? 1 : 0
  source                     = "./modules/private-storage-account"
  naming_prefix              = local.naming_prefix
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  private_endpoint_subnet_id = azurerm_subnet.private.id
  private_dns_zone_virtual_networks = {
    network = azurerm_virtual_network.this.id
  }
}

# private vey vault
module "private_key_vault" {
  count                       = var.add_private_key_vault ? 1 : 0
  source                      = "./modules/private-key-vault"
  naming_prefix               = local.naming_prefix
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  tenant_id                   = var.tenant_id
  key_vault_full_access_users = var.key_vault_full_access_users
  key_vault_readers = {
    "ADF managed identity" = module.adf_workspace.0.data_factory_managed_identity
  }
  key_vault_secrets          = merge(var.key_vault_secrets, { "storage-account-sas" = module.private_storage_account.0.sas_url_query_string })
  private_endpoint_subnet_id = azurerm_subnet.private.id
  private_dns_zone_virtual_networks = {
    network = azurerm_virtual_network.this.id
  }
}

# GPG function app
#module "gpg_function_app" {
#  count               = var.add_gpg_function_app ? 1 : 0
#  source              = "./modules/gpg-function-app"
#  naming_prefix       = local.naming_prefix
#  resource_group_name = azurerm_resource_group.this.name
#  location            = azurerm_resource_group.this.location
#  tenant_id           = var.tenant_id
#}

# GPG container app
module "gpg_container_app" {
  count                      = var.add_gpg_container_app ? 1 : 0
  source                     = "./modules/gpg-container-app"
  naming_prefix              = local.naming_prefix
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  tenant_id                  = var.tenant_id
  virtual_network_id         = azurerm_virtual_network.this.id
  infrastructure_subnet_id   = azurerm_subnet.cae.id
  is_internal                = true
  allow_insecure_connections = false
  acr_server                 = var.acr_server
  acr_username               = var.acr_username
  acr_password               = var.acr_password
  image_name                 = "global.gpg:latest"
  target_port                = 5297
  min_replicas               = 1
  max_replicas               = 1
}

# ADF
module "adf_workspace" {
  count                       = var.add_adf_workspace ? 1 : 0
  source                      = "./modules/adf-workspace"
  naming_prefix               = local.naming_prefix
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  add_private_storage_account = var.add_private_storage_account
  add_private_key_vault       = var.add_private_key_vault
  add_self_hosted_ir          = var.add_adf_self_hosted_ir
  private_storage_account_id  = var.add_private_storage_account ? module.private_storage_account.0.private_storage_account_id : null
  private_key_vault_id        = var.add_private_key_vault ? module.private_key_vault.0.private_key_vault_id : null
}

# ADF SHIR
module "adf_shir" {
  count               = var.add_adf_self_hosted_ir ? 1 : 0
  source              = "./modules/adf-shir"
  naming_prefix       = local.naming_prefix
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.ci.id
  auth_key            = module.adf_workspace.0.data_factory_shir_auth_key
  acr_server          = var.acr_server
  acr_username        = var.acr_username
  acr_password        = var.acr_password
  image_name          = "global.azure.selfhostedruntimecontainer:latest"
}

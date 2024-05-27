resource "azurerm_storage_account" "this" {
  name                          = replace(local.storage_account_name, "-", "")
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = var.account_tier
  account_kind                  = var.hierarchical_namespace_enabled ? "BlockBlobStorage" : var.account_kind
  account_replication_type      = var.account_replication_type
  public_network_access_enabled = false
  is_hns_enabled                = var.hierarchical_namespace_enabled
  sftp_enabled                  = var.sftp_enabled
}

resource "azurerm_storage_container" "sftp" {
  count                = var.sftp_enabled ? 1 : 0
  name                 = var.sftp_container_name
  storage_account_name = azurerm_storage_account.this.name
}

resource "azurerm_storage_account_local_user" "this" {
  count                = var.sftp_enabled ? 1 : 0
  name                 = var.username
  storage_account_id   = azurerm_storage_account.this.id
  ssh_key_enabled      = true
  ssh_authorized_key {
    description = "key1"
    key         = var.ssh_public_key
  }
  permission_scope {
    permissions {
      read   = true
      list = true
      create = true
      write = true
    }
    service       = "blob"
    resource_name = azurerm_storage_container.sftp.0.name
  }
}

resource "azurerm_private_endpoint" "this" {
  name                = "${local.storage_account_name}-pep"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${local.storage_account_name}-pepcon"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${local.storage_account_name}-pepdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.this.id]
  }
}

resource "azurerm_private_dns_zone" "this" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each              = var.private_dns_zone_virtual_networks
  name                  = "${local.storage_account_name}-${each.key}-vnet-pdz-lnk"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = each.value
}

data "azurerm_storage_account_sas" "this" {
  connection_string = azurerm_storage_account.this.primary_connection_string
  https_only        = true

  resource_types {
    service   = true
    container = false
    object    = false
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2024-01-01T00:00:00Z"
  expiry = "2025-01-01T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = true
    add     = true
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}

resource "azurerm_eventhub_namespace" "this" {
  name                = local.event_hub_namespace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  capacity            = 1
  auto_inflate_enabled = true
  maximum_throughput_units = 3
}

resource "azurerm_eventhub" "this" {
  name                = local.event_hub_name
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = var.resource_group_name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "send" {
  name                = "${local.event_hub_namespace_name}-send"
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.this.name
  resource_group_name = var.resource_group_name
  listen              = false
  send                = true
  manage              = false
}

resource "azurerm_eventhub_authorization_rule" "listen" {
  name                = "${local.event_hub_namespace_name}-listen"
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.this.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = false
  manage              = false
}

#resource "azurerm_private_endpoint" "this" {
#  name                = "${local.event_hub_namespace_name}-pep"
#  resource_group_name = var.resource_group_name
#  location            = var.location
#  subnet_id           = var.private_endpoint_subnet_id
#
#  private_service_connection {
#    name                           = "${local.event_hub_namespace_name}-pepcon"
#    private_connection_resource_id = azurerm_eventhub_namespace.this.id
#    subresource_names              = ["namespace"]
#    is_manual_connection           = false
#  }
#
#  private_dns_zone_group {
#    name                 = "${local.event_hub_namespace_name}-pepdzg"
#    private_dns_zone_ids = [azurerm_private_dns_zone.this.id]
#  }
#}
#
#resource "azurerm_private_dns_zone" "this" {
#  name                = "privatelink.servicebus.windows.net"
#  resource_group_name = var.resource_group_name
#}
#
#resource "azurerm_private_dns_zone_virtual_network_link" "this" {
#  for_each              = var.private_dns_zone_virtual_networks
#  name                  = "${local.storage_account_name}-${each.key}-vnet-pdz-lnk"
#  resource_group_name   = var.resource_group_name
#  private_dns_zone_name = azurerm_private_dns_zone.this.name
#  virtual_network_id    = each.value
#}

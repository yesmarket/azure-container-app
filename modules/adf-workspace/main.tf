resource "azurerm_data_factory" "this" {
  name                            = local.adf_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  managed_virtual_network_enabled = true

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_data_factory_managed_private_endpoint" "storage_account" {
  count              = var.add_private_storage_account ? 1 : 0
  name               = "${local.adf_name}-st-pep"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = var.private_storage_account_id
  subresource_name   = "blob"
}

resource "azurerm_data_factory_managed_private_endpoint" "key_vault" {
  count              = var.add_private_key_vault ? 1 : 0
  name               = "${local.adf_name}-kv-pep"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = var.private_key_vault_id
  subresource_name   = "vault"
}

#resource "azurerm_data_factory_managed_private_endpoint" "container_app" {
#  count              = var.add_gpg_container_app ? 1 : 0
#  name               = "${local.adf_name}-ca-pep"
#  data_factory_id    = azurerm_data_factory.this.id
#  target_resource_id = var.private_key_vault_id
#  subresource_name   = "vault"
#}

resource "azurerm_data_factory_integration_runtime_self_hosted" "this" {
  count           = var.add_self_hosted_ir ? 1 : 0
  name            = "${local.adf_name}-ir-self-hosted"
  data_factory_id = azurerm_data_factory.this.id
}

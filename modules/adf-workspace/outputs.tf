output "data_factory_managed_identity" {
  value = azurerm_data_factory.this.identity.0.principal_id
}

output "data_factory_shir_auth_key" {
  value = var.add_self_hosted_ir ? azurerm_data_factory_integration_runtime_self_hosted.this.0.primary_authorization_key : null
}

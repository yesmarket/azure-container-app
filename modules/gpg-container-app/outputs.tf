output "container_app_fqdn" {
  value = azurerm_container_app.this.latest_revision_fqdn
}

output "container_app_environment_default_domain" {
  value = azurerm_container_app_environment.this.default_domain
}

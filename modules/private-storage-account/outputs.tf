output "private_storage_account_id" {
  value = azurerm_storage_account.this.id
}

output "sas_url_query_string" {
  value = data.azurerm_storage_account_sas.this.sas
}

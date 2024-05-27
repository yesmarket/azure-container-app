resource "azurerm_log_analytics_workspace" "this" {
  name                = "${local.fn_app_name}-log"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "this" {
  name                = "${local.fn_app_name}-appi"
  resource_group_name = var.resource_group_name
  location            = var.location
  application_type    = "web"
  retention_in_days   = 30
  workspace_id        = azurerm_log_analytics_workspace.this.id
}

resource "azurerm_storage_account" "this" {
  name                     = replace("${local.fn_app_name}-st", "-", "")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "this" {
  name                = "${local.fn_app_name}-asp"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "this" {
  name                = local.fn_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  https_only          = true

  service_plan_id = azurerm_service_plan.this.id

  storage_account_name       = azurerm_storage_account.this.name
  storage_account_access_key = azurerm_storage_account.this.primary_access_key

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE       = "1",
    FUNCTIONS_WORKER_RUNTIME       = "dotnet",
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.this.instrumentation_key,
    AzureWebJobsDisableHomepage    = "true",
  }

  site_config {
    cors {
      allowed_origins = ["*", "https://portal.azure.com"]
    }
  }

#  auth_settings_v2 {
#    auth_enabled = true
#    require_authentication = true
#    unauthenticated_action = "Return401"
#    default_provider = "azureactivedirectory"
#    active_directory_v2 {
#      client_id = ""
#      tenant_auth_endpoint = "https://login.microsoftonline.com/v2.0/${var.tenant_id}/"
#      client_secret_setting_name = var.client_secret
#      allowed_identities = [
#        "https://${lookup(each.value, "appservice_name")}.azurewebsites.net"
#      ]
#    }
#  }

  identity {
    type = "SystemAssigned"
  }
}

data "local_file" "function_app_zip" {
  filename = "${path.module}/resources/function-app.zip"
}

resource "null_resource" "function_app_publish" {
  provisioner "local-exec" {
    command = "az webapp deployment source config-zip --resource-group ${var.resource_group_name} --name ${azurerm_linux_function_app.this.name} --src ${data.local_file.function_app_zip.filename}"
  }
  triggers = {
    hash = data.local_file.function_app_zip.content_md5
  }
}

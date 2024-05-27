resource "azurerm_container_group" "this" {
  name                = local.ci_name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Private"
  os_type             = "Windows"
  restart_policy      = "Never"

  image_registry_credential {
    server   = var.acr_server
    username = var.acr_username
    password = var.acr_password
  }

  container {
    name   = local.ca_container_name
    image  = "${var.acr_server}/${var.image_name}"
    cpu    = var.cpu
    memory = var.memory

    ports {
      port     = var.port
      protocol = "TCP"
    }

    environment_variables = {
      AUTH_KEY = var.auth_key
    }
  }

  subnet_ids = [var.subnet_id]
}

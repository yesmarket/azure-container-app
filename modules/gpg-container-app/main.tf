resource "azurerm_log_analytics_workspace" "this" {
  name                = "${local.ca_name}-log"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "this" {
  name                           = local.cae_name
  location                       = var.location
  resource_group_name            = var.resource_group_name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.this.id
  infrastructure_subnet_id       = var.infrastructure_subnet_id
  internal_load_balancer_enabled = var.is_internal
  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
}

resource "azurerm_container_app" "this" {
  name                         = local.ca_name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.this.id
  revision_mode                = "Single"

  registry {
    server               = var.acr_server
    username             = var.acr_username
    password_secret_name = local.ca_secret_name
  }

  secret { 
    name  = local.ca_secret_name
    value = var.acr_password
  }

  template {
    container {
      name   = local.ca_container_name
      image  = "${var.acr_server}/${var.image_name}"
      cpu    = var.cpu
      memory = var.memory
    }
    max_replicas = var.max_replicas
    min_replicas = var.min_replicas
    http_scale_rule {
      name                = "${local.ca_name}-hsr"
      concurrent_requests = 1
    }
  }

  ingress {
    allow_insecure_connections = var.allow_insecure_connections
    external_enabled           = var.is_internal
    target_port                = var.target_port
    #exposed_port               = var.exposed_port
    #transport                  = "tcp"
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

resource "azurerm_private_dns_zone" "this" {
  name                = azurerm_container_app_environment.this.default_domain
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "${local.ca_name}-pdz-lnk"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = var.virtual_network_id
}

resource "azurerm_private_dns_a_record" "star" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = var.resource_group_name
  ttl                 = 5
  records             = [azurerm_container_app_environment.this.static_ip_address]
}

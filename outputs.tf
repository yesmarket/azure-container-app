output "tailscale_subnet_router_public_ip" {
  value = values(module.tailscale_subnet_router).*.public_ip
}

output "tailscale_subnet_router_private_ip" {
  value = values(module.tailscale_subnet_router).*.private_ip
}

output "gpg_container_app_fqdn" {
  value = module.gpg_container_app.0.container_app_fqdn
}

output "gpg_container_app_environment_default_domain" {
  value = module.gpg_container_app.0.container_app_environment_default_domain
}

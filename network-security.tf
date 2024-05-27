#resource "azurerm_network_security_group" "tailscale_nsg" {
#  name                = "tailscale-nsg"
#  resource_group_name = azurerm_resource_group.this.name
#  location            = azurerm_resource_group.this.location
#}
#
#resource "azurerm_network_security_rule" "ssh_22_inbound_nsgsr" {
#  name                        = "ssh-22-inbound-nsgsr"
#  priority                    = 100
#  direction                   = "Inbound"
#  access                      = "Allow"
#  protocol                    = "Tcp"
#  source_port_range           = "*"
#  destination_port_range      = "22"
#  source_address_prefix       = "VirtualNetwork"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.this.name
#  network_security_group_name = azurerm_network_security_group.tailscale_nsg.name
#}
#
#resource "azurerm_network_security_rule" "ssh_22_outbound_nsgsr" {
#  name                        = "ssh-22-outbound-nsgsr"
#  priority                    = 101
#  direction                   = "Outbound"
#  access                      = "Allow"
#  protocol                    = "Tcp"
#  source_port_range           = "*"
#  destination_port_range      = "22"
#  source_address_prefix       = "*"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.this.name
#  network_security_group_name = azurerm_network_security_group.tailscale_nsg.name
#}
#
#resource "azurerm_network_security_rule" "icmp_inbound_nsgsr" {
#  name                        = "allow-ping-inbound-nsgsr"
#  priority                    = 102
#  direction                   = "Inbound"
#  access                      = "Allow"
#  protocol                    = "Icmp"
#  source_port_range           = "*"
#  destination_port_range      = "*"
#  source_address_prefix       = "VirtualNetwork"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.this.name
#  network_security_group_name = azurerm_network_security_group.tailscale_nsg.name
#}
#
#resource "azurerm_network_security_rule" "icmp_outbound_nsgsr" {
#  name                        = "allow-ping-outbound-nsgsr"
#  priority                    = 103
#  direction                   = "Outbound"
#  access                      = "Allow"
#  protocol                    = "Icmp"
#  source_port_range           = "*"
#  destination_port_range      = "*"
#  source_address_prefix       = "*"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.this.name
#  network_security_group_name = azurerm_network_security_group.tailscale_nsg.name
#}
#
#resource "azurerm_network_security_rule" "wireguard_51820_inbound_nsgsr" {
#  name                        = "wireguard-51820-inbound-nsgsr"
#  priority                    = 104
#  direction                   = "Inbound"
#  access                      = "Allow"
#  protocol                    = "Udp"
#  source_port_range           = "*"
#  destination_port_range      = "51820"
#  source_address_prefix       = "*"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.this.name
#  network_security_group_name = azurerm_network_security_group.tailscale_nsg.name
#}
#
#resource "azurerm_network_security_rule" "wireguard_51820_outbound_nsgsr" {
#  name                        = "wireguard-51820-outbound-nsgsr"
#  priority                    = 105
#  direction                   = "Outbound"
#  access                      = "Allow"
#  protocol                    = "Udp"
#  source_port_range           = "*"
#  destination_port_range      = "51820"
#  source_address_prefix       = "*"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.this.name
#  network_security_group_name = azurerm_network_security_group.tailscale_nsg.name
#}
#
#resource "azurerm_network_security_rule" "wireguard_41641_inbound_nsgsr" {
#  name                        = "wireguard-41641-inbound-nsgsr"
#  priority                    = 106
#  direction                   = "Inbound"
#  access                      = "Allow"
#  protocol                    = "Udp"
#  source_port_range           = "*"
#  destination_port_range      = "41641"
#  source_address_prefix       = "*"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.this.name
#  network_security_group_name = azurerm_network_security_group.tailscale_nsg.name
#}
#
#resource "azurerm_network_security_rule" "wireguard_41641_outbound_nsgsr" {
#  name                        = "wireguard-41641-outbound-nsgsr"
#  priority                    = 107
#  direction                   = "Outbound"
#  access                      = "Allow"
#  protocol                    = "Udp"
#  source_port_range           = "*"
#  destination_port_range      = "41641"
#  source_address_prefix       = "*"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.this.name
#  network_security_group_name = azurerm_network_security_group.tailscale_nsg.name
#}
#
#resource "azurerm_network_security_rule" "wireguard_3478_inbound_nsgsr" {
#  name                        = "wireguard-3478-inbound-nsgsr"
#  priority                    = 108
#  direction                   = "Inbound"
#  access                      = "Allow"
#  protocol                    = "Udp"
#  source_port_range           = "*"
#  destination_port_range      = "3478"
#  source_address_prefix       = "*"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.this.name
#  network_security_group_name = azurerm_network_security_group.tailscale_nsg.name
#}
#
#resource "azurerm_network_security_rule" "wireguard_3478_outbound_nsgsr" {
#  name                        = "wireguard-3478-outbound-nsgsr"
#  priority                    = 109
#  direction                   = "Outbound"
#  access                      = "Allow"
#  protocol                    = "Udp"
#  source_port_range           = "*"
#  destination_port_range      = "3478"
#  source_address_prefix       = "*"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.this.name
#  network_security_group_name = azurerm_network_security_group.tailscale_nsg.name
#}
#
#resource "azurerm_network_security_rule" "https_443_inbound_nsgsr" {
#  name                        = "https-443-inbound-nsgsr"
#  priority                    = 110
#  direction                   = "Inbound"
#  access                      = "Allow"
#  protocol                    = "Tcp"
#  source_port_range           = "*"
#  destination_port_range      = "443"
#  source_address_prefix       = "*"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.this.name
#  network_security_group_name = azurerm_network_security_group.tailscale_nsg.name
#}
#
#resource "azurerm_network_security_rule" "https_443_outbound_nsgsr" {
#  name                        = "https-443-outbound-nsgsr"
#  priority                    = 111
#  direction                   = "Outbound"
#  access                      = "Allow"
#  protocol                    = "Tcp"
#  source_port_range           = "*"
#  destination_port_range      = "443"
#  source_address_prefix       = "*"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.this.name
#  network_security_group_name = azurerm_network_security_group.tailscale_nsg.name
#}
#
#resource "azurerm_subnet_network_security_group_association" "tailscale_snet_nsga" {
#  subnet_id                 = azurerm_subnet.ingress.id
#  network_security_group_id = azurerm_network_security_group.tailscale_nsg.id
#}

resource "azurerm_network_security_group" "nsg" {

  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "ssh_rule" {

  name                        = var.ssh_rule_name
  priority                    = var.ssh_priority
  direction                   = var.ssh_direction
  access                      = var.ssh_access
  protocol                    = var.ssh_protocol

  source_port_range           = var.ssh_source_port_range
  destination_port_range      = var.ssh_destination_port_range

  source_address_prefix       = var.ssh_source_address_prefix
  destination_address_prefix  = var.ssh_destination_address_prefix

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "http_rule" {

  name                        = var.http_rule_name
  priority                    = var.http_priority
  direction                   = var.http_direction
  access                      = var.http_access
  protocol                    = var.http_protocol

  source_port_range           = var.http_source_port_range
  destination_port_range      = var.http_destination_port_range

  source_address_prefix       = var.http_source_address_prefix
  destination_address_prefix  = var.http_destination_address_prefix

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "https_rule" {

  name                        = var.https_rule_name
  priority                    = var.https_priority
  direction                   = var.https_direction
  access                      = var.https_access
  protocol                    = var.https_protocol

  source_port_range           = var.https_source_port_range
  destination_port_range      = var.https_destination_port_range

  source_address_prefix       = var.https_source_address_prefix
  destination_address_prefix  = var.https_destination_address_prefix

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
resource "azurerm_virtual_network_peering" "peer" {

  name = var.peering_name

  resource_group_name = var.resource_group_name

  virtual_network_name = var.vnet_name

  remote_virtual_network_id = var.remote_vnet_id

  allow_virtual_network_access = true
}
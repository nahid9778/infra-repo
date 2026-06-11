resource "azurerm_public_ip" "pip" {

  name                = "${var.bastion_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_subnet" "bastion" {

  name = "AzureBastionSubnet"

  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name

  address_prefixes = ["10.0.10.0/24"]
}

resource "azurerm_bastion_host" "bastion" {

  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {

    name = "configuration"

    subnet_id = azurerm_subnet.bastion.id

    public_ip_address_id = azurerm_public_ip.pip.id
  }
}
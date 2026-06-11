resource "azurerm_lb" "lb" {

  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku = "Standard"

  frontend_ip_configuration {

    name = "private-frontend"

    subnet_id = var.subnet_id

    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "pool" {

  loadbalancer_id = azurerm_lb.lb.id
  name            = "backend-pool"
}

resource "azurerm_network_interface_backend_address_pool_association" "web_vm" {

  network_interface_id = var.web_nic_id

  ip_configuration_name = "internal"

  backend_address_pool_id = azurerm_lb_backend_address_pool.pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "app_vm" {

  network_interface_id = var.app_nic_id

  ip_configuration_name = "internal"

  backend_address_pool_id = azurerm_lb_backend_address_pool.pool.id
}

resource "azurerm_lb_probe" "probe" {

  loadbalancer_id = azurerm_lb.lb.id

  name = "http-probe"
  port = 80
}

resource "azurerm_lb_rule" "rule" {

  loadbalancer_id = azurerm_lb.lb.id

  name     = "http-rule"
  protocol = "Tcp"

  frontend_port = 80
  backend_port  = 80

  frontend_ip_configuration_name = "private-frontend"

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.pool.id
  ]

  probe_id = azurerm_lb_probe.probe.id
}
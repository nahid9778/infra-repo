resource "azurerm_storage_account" "storage" {

  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = false

  min_tls_version = "TLS1_2"

  allow_nested_items_to_be_public = false
}

resource "azurerm_private_endpoint" "storage_pe" {

  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name

  subnet_id = var.subnet_id

  private_service_connection {

    name                           = "storage-private-connection"
    private_connection_resource_id = azurerm_storage_account.storage.id

    is_manual_connection = false

    subresource_names = ["blob"]
  }
}
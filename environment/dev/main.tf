  module "rg" {
    source = "../../modules/resource-group"

    rg_name  = "dev-rg"
    location = var.location
  }

  module "vnet1" {
    source = "../../modules/vnet"

    vnet_name      = "dev-vnet-1"
    location       = var.location
    resource_group = module.rg.rg_name

    address_space = ["10.0.0.0/16"]
  }

  module "vnet2" {
    source = "../../modules/vnet"

    vnet_name      = "dev-vnet-2"
    location       = var.location
    resource_group = module.rg.rg_name

    address_space = ["10.1.0.0/16"]
  }

  module "vnet1_to_vnet2" {
    source = "../../modules/peering"

    peering_name        = "vnet1-to-vnet2"
    resource_group_name = module.rg.rg_name

    vnet_name       = module.vnet1.vnet_name
    remote_vnet_id  = module.vnet2.vnet_id
  }

  module "vnet2_to_vnet1" {
    source = "../../modules/peering"

    peering_name        = "vnet2-to-vnet1"
    resource_group_name = module.rg.rg_name

    vnet_name      = module.vnet2.vnet_name
    remote_vnet_id = module.vnet1.vnet_id
  }

  module "nsg" {

    source = "../../modules/nsg"

    nsg_name            = "dev-nsg"
    location            = var.location
    resource_group_name = module.rg.rg_name

    # SSH

    ssh_rule_name                  = "Allow-SSH"
    ssh_priority                   = 100
    ssh_direction                  = "Inbound"
    ssh_access                     = "Allow"
    ssh_protocol                   = "Tcp"

    ssh_source_port_range          = "*"
    ssh_destination_port_range     = "22"

    ssh_source_address_prefix      = "*"
    ssh_destination_address_prefix = "*"

    # HTTP

    http_rule_name                  = "Allow-HTTP"
    http_priority                   = 110
    http_direction                  = "Inbound"
    http_access                     = "Allow"
    http_protocol                   = "Tcp"

    http_source_port_range          = "*"
    http_destination_port_range     = "80"

    http_source_address_prefix      = "*"
    http_destination_address_prefix = "*"

    # HTTPS

    https_rule_name                  = "Allow-HTTPS"
    https_priority                   = 120
    https_direction                  = "Inbound"
    https_access                     = "Allow"
    https_protocol                   = "Tcp"

    https_source_port_range          = "*"
    https_destination_port_range     = "443"

    https_source_address_prefix      = "*"
    https_destination_address_prefix = "*"
  }

  module "subnet" {
    source = "../../modules/subnet"

    for_each = {
      web = "10.0.1.0/24"
      app = "10.0.2.0/24"
    }

    subnet_name          = each.key
    resource_group_name  = module.rg.rg_name
    virtual_network_name = module.vnet1.vnet_name

    address_prefixes = [each.value]

    nsg_id = module.nsg.nsg_id
  }

  module "web_vm" {
    source = "../../modules/vm"

    vm_name = "web-vm"
    vm_size = "Standard_D2s_v3"

    location            = var.location
    resource_group_name = module.rg.rg_name

    subnet_id = module.subnet["web"].subnet_id

    admin_username = "azureuser"
    admin_password = "Password1234!"
  }

  module "app_vm" {
    source = "../../modules/vm"

    vm_name = "app-vm"
    vm_size = "Standard_D2s_v3"

    location            = var.location
    resource_group_name = module.rg.rg_name

    subnet_id = module.subnet["app"].subnet_id

    admin_username = "azureuser"
    admin_password = "Password1234!"
  }

  module "storage_account" {

    source = "../../modules/storage-account"

    storage_account_name = "devstoragenahid01"

    location            = var.location
    resource_group_name = module.rg.rg_name

    private_endpoint_name = "storage-private-endpoint"

    subnet_id = module.subnet["app"].subnet_id
  }

  module "internal_lb" {
    source = "../../modules/load_balancer"

    lb_name             = "internal-lb"
    location            = var.location
    resource_group_name = module.rg.rg_name

    subnet_id = module.subnet["app"].subnet_id

    web_nic_id = module.web_vm.nic_id
    app_nic_id = module.app_vm.nic_id
  }

  module "bastion" {
    source = "../../modules/bastion"

    bastion_name        = "dev-bastion"
    location            = var.location
    resource_group_name = module.rg.rg_name

    vnet_name = module.vnet1.vnet_name
  }
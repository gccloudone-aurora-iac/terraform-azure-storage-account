#################
### Providers ###
#################

provider "azurerm" {
  features {}
}

####################################
### Azure Resource Prerequisites ###
####################################

resource "azurerm_resource_group" "storage" {
  name     = "example-storage-rg"
  location = "canada central"
}

resource "azurerm_resource_group" "network" {
  name     = "example-network-rg"
  location = "canada central"
}

### vnet one ###

resource "azurerm_virtual_network" "vnet_one" {
  name                = "example-one-vnet"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
}

resource "azurerm_subnet" "storage_vnet_one" {
  name                 = "storage"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet_one.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

### vnet two ###

resource "azurerm_virtual_network" "vnet_two" {
  name                = "example-two-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_subnet" "storage_vnet_two" {
  name                 = "storage"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet_two.name
  address_prefixes     = ["10.1.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

########################
### Key Vault Module ###
########################

module "example_storage" {
  source = "../../"

  naming_convention = "gc"
  user_defined      = "example"

  azure_resource_attributes = {
    department_code = "Gc"
    owner           = "ABC"
    project         = "aur"
    environment     = "dev"
    location        = azurerm_resource_group.storage.location
    instance        = 0
  }

  resource_group_name = azurerm_resource_group.storage.name

  public_network_access_enabled = true
  network_default_action        = "Deny"
  virtual_network_subnet_ids    = [azurerm_subnet.storage_vnet_one.id, azurerm_subnet.storage_vnet_two.id]

  containers = [
    "container1",
    "container2"
  ]

  tags = {
    env = "development"
  }
}

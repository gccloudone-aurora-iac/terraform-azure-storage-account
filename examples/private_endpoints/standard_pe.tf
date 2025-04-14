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

### networking ###

resource "azurerm_resource_group" "network" {
  name     = "network-management-rg"
  location = "canada central"
}

resource "azurerm_private_dns_zone" "network" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.network.name
}

### vnet one ###

resource "azurerm_virtual_network" "vnet_one" {
  name                = "example-one-vnet"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
}

resource "azurerm_subnet" "storage_vnet_one" {
  name                 = "storage-one"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet_one.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_one" {
  name                  = "mydomain-${azurerm_virtual_network.vnet_one.name}-pdl"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.network.name
  virtual_network_id    = azurerm_virtual_network.vnet_one.id
}

### vnet two ###

resource "azurerm_virtual_network" "vnet_two" {
  name                = "example-two-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_subnet" "storage_vnet_two" {
  name                 = "storage-two"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet_two.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_two" {
  name                  = "mydomain-${azurerm_virtual_network.vnet_two.name}-pdl"
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.network.name
  virtual_network_id    = azurerm_virtual_network.vnet_two.id
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

  network_default_action = "Deny"
  private_endpoints = [
    {
      sub_resource_name   = "blob"
      subnet_id           = azurerm_subnet.storage_vnet_two.id
      private_dns_zone_id = azurerm_private_dns_zone.network.id
    }
  ]

  containers = [
    "container1",
    "container2"
  ]

  tags = {
    env = "development"
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.vnet_one,
    azurerm_private_dns_zone_virtual_network_link.vnet_two
  ]
}

#################
### Providers ###
#################

provider "azurerm" {
  features {}
}

####################################
### Azure Resource Prerequisites ###
####################################

resource "azurerm_resource_group" "example" {
  name     = "example-storage-rg"
  location = "canada central"
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

  resource_group_name = azurerm_resource_group.example.name

  public_network_access_enabled = true
  network_default_action        = "Allow"

  hns_enabled = true
  containers = [
    "container1",
    "container2"
  ]

  tags = {
    env = "development"
  }
}

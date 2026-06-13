
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
resource "azurerm_virtual_network" "vnet" {
  name                = "k8s-vnet"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  address_space = ["172.16.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "k8s-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = ["172.16.10.0/24"]
}
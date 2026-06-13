resource "azurerm_network_security_group" "nsg" {
  name                = "k8s-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {

  subnet_id = azurerm_subnet.subnet.id

  network_security_group_id = azurerm_network_security_group.nsg.id
}
resource "azurerm_network_interface" "master_nic" {

  name                = "master-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {

    name                          = "internal"

    subnet_id                     = azurerm_subnet.subnet.id

    private_ip_address_allocation = "Dynamic"

    public_ip_address_id          = azurerm_public_ip.master_pip.id
  }
}

resource "azurerm_network_interface" "node01_nic" {

  name                = "node01-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {

    name                          = "internal"

    subnet_id                     = azurerm_subnet.subnet.id

    private_ip_address_allocation = "Dynamic"

    public_ip_address_id          = azurerm_public_ip.node01_pip.id
  }
}
resource "azurerm_public_ip" "master_pip" {
  name                = "master-pip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_public_ip" "node01_pip" {
  name                = "node01-pip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_network_interface" "node_nic" {
  count = var.node_count

  name                = "node${format("%02d", count.index + 1)}-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {

    name = "internal"

    subnet_id = azurerm_subnet.subnet.id

    private_ip_address_allocation = "Static"

    private_ip_address = "172.16.10.${count.index + 11}"

  }
}

# 
resource "azurerm_public_ip" "jump_pip" {
  name                = "jump_pip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_network_interface" "jump_nic" {

  name                = "jump-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_configuration {

    name = "internal"

    subnet_id = azurerm_subnet.subnet.id

    private_ip_address_allocation = "Static"

    private_ip_address = "172.16.10.10"

    public_ip_address_id = azurerm_public_ip.jump_pip.id
  }
}
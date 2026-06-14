resource "azurerm_network_security_rule" "nodeport" {

  name = "AllowNodePort"

  priority = 120

  direction = "Inbound"

  access = "Allow"

  protocol = "Tcp"

  source_port_range = "*"

  destination_port_range = "30000-32767"

  source_address_prefix = "*"

  destination_address_prefix = "*"

  resource_group_name = data.azurerm_resource_group.rg.name

  network_security_group_name = azurerm_network_security_group.nsg.name
}
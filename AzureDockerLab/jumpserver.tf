resource "azurerm_linux_virtual_machine" "jumpserver" {

  name = "jumpserver"

  resource_group_name = data.azurerm_resource_group.rg.name

  location = data.azurerm_resource_group.rg.location

  size = "Standard_D2s_v3"

  admin_username = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.jump_nic.id
  ]

  disable_password_authentication = false

  admin_password = var.admin_password
  source_image_reference {

    publisher = "Canonical"

    offer = "0001-com-ubuntu-server-jammy"

    sku = "22_04-lts"

    version = "latest"
  }

  os_disk {

    caching = "ReadWrite"

    storage_account_type = "Standard_LRS"
  }
}

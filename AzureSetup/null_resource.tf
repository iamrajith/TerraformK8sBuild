
resource "null_resource" "copy_file" {
  depends_on = [azurerm_linux_virtual_machine.master]

  provisioner "file" {
    source      = "playbooks"
    destination = "/home/rajith"

    connection {
      type     = "ssh"
      user     = "rajith"
      password = "Test@12345678"
      host     = azurerm_public_ip.master_pip.ip_address

    }

  }

}

resource "null_resource" "install_ansible" {

  depends_on = [
    azurerm_linux_virtual_machine.master
  ]

  connection {
    type     = "ssh"
    host     = azurerm_public_ip.master_pip.ip_address
    user     = var.admin_username
    password = var.admin_password
  }

  provisioner "remote-exec" {

    inline = [
      "sudo apt update",
      "sudo apt install software-properties-common",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt install -y ansible"
    ]
  }
}

resource "null_resource" "setup_master" {

  depends_on = [
    azurerm_linux_virtual_machine.master,
    null_resource.install_ansible
  ]

  connection {
    type     = "ssh"
    host     = azurerm_public_ip.master_pip.ip_address
    user     = var.admin_username
    password = var.admin_password
  }

  provisioner "remote-exec" {

    inline = [
      "export ANSIBLE_HOST_KEY_CHECKING=False",
      #"ssh -o StrictHostKeyChecking=no rajith@172.16.10.5",
      #"ssh -o StrictHostKeyChecking=no rajith@172.16.10.4",
      #"ssh -o StrictHostKeyChecking=no rajith@172.16.10.6",
      "/usr/bin/ansible-playbook -i /home/rajith/playbooks/Inventory /home/rajith/playbooks/master-node.yml"
    ]
  }
}


resource "null_resource" "setup_worker" {

  depends_on = [
    azurerm_linux_virtual_machine.master,
    null_resource.install_ansible,
    null_resource.setup_master
    
  ]

  connection {
    type     = "ssh"
    host     = azurerm_public_ip.master_pip.ip_address
    user     = var.admin_username
    password = var.admin_password
  }

  provisioner "remote-exec" {

    inline = [
      "export ANSIBLE_HOST_KEY_CHECKING=False",
      #"ssh -o StrictHostKeyChecking=no rajith@172.16.10.5",
      #"ssh -o StrictHostKeyChecking=no rajith@172.16.10.4",
      #"ssh -o StrictHostKeyChecking=no rajith@172.16.10.6",
      "/usr/bin/ansible-playbook -i /home/rajith/playbooks/Inventory /home/rajith/playbooks/worker-node.yml"
    ]
  }
}

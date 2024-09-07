
resource "aws_instance" "Jumpserver" {
  #count = 1
  ami = var.aws_ami_id
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.my_subnet.id
  private_ip = "172.16.10.10"
  key_name = "testkey"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_sshweb.id]
  user_data = <<-EOF
  #!/bin/bash
  sudo hostnamectl set-hostname jumpserver
  sudo amazon-linux-extras install -y epel
  sudo useradd rajith
  echo -e 'rajith\nrajith' | sudo passwd rajith
  echo 'rajith ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/devops
  sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  sudo systemctl restart sshd.service
  sudo yum install -y python3
  sudo yum install -y vim
  sudo yum install -y git
  sudo yum update -y
  sudo sed -i -e '$a\'$'\n''172.16.10.100 master' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.101 node01' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.102 node02' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.103 node03' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.104 node04' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.10 Jumpserver' /etc/hosts
  EOF

#Copy the ansible invetory to the jump server 

provisioner "file" {
  source      = "inventory"
  destination = "/home/rajith/inventory"

  connection {
    type     = "ssh"
    user     = "rajith"
    password = "rajith"
    host     = self.public_ip
  }
  
}

#Copy the ansible configuration file to the jump server 
provisioner "file" {
  source      = "ansible.cfg"
  destination = "/home/rajith/ansible.cfg"

  connection {
    type     = "ssh"
    user     = "rajith"
    password = "rajith"
    host     = self.public_ip
  }
}


#Copy the ansible playbook  to the jump server 
provisioner "file" {
  source      = "InititalSetup.yaml"
  destination = "/home/rajith/InititalSetup.yaml"

  connection {
    type     = "ssh"
    user     = "rajith"
    password = "rajith"
    host     = self.public_ip
  }
}

#Copy the ansible playbook  to the jump server 
provisioner "file" {
  source      = "JumpServerConfig.yaml"
  destination = "/home/rajith/JumpServerConfig.yaml"

  connection {
    type     = "ssh"
    user     = "rajith"
    password = "rajith"
    host     = self.public_ip
  }
}

#Copy the ansible playbook  to the jump server 
provisioner "file" {
  source      = "InitializetheMaster.yaml"
  destination = "/home/rajith/InitializetheMaster.yaml"

  connection {
    type     = "ssh"
    user     = "rajith"
    password = "rajith"
    host     = self.public_ip
  }
}

#Copy the ansible playbook  to the jump server 
provisioner "file" {
  source      = "JoinTheNodesToK8s.yaml"
  destination = "/home/rajith/JoinTheNodesToK8s.yaml"

  connection {
    type     = "ssh"
    user     = "rajith"
    password = "rajith"
    host     = self.public_ip
  }
}

#Copy the ansible playbook  to the jump server 
provisioner "file" {
  source      = "InstallCNI.yaml"
  destination = "/home/rajith/InstallCNI.yaml"

  connection {
    type     = "ssh"
    user     = "rajith"
    password = "rajith"
    host     = self.public_ip
  }
}

#Install and setup ansible server
provisioner "remote-exec" {
  inline = [  
  "sudo yum update -y" ,
  "sudo yum install -y python3" ,
  "sudo yum install -y ansible" ,
  "ansible-playbook --limit  jumpserver JumpServerConfig.yaml" ,

  ]
}
connection {
    type     = "ssh"
    user     = "rajith"
    password = "rajith"
    host     = self.public_ip
  }


  tags = {
    Name = "JumpServer"
  }
}



resource "aws_instance" "master" {
  #count = 4
  ami =  var.aws_ami_id
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.my_subnet.id
  private_ip = "172.16.10.100"
  key_name = "testkey"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_sshweb.id]
  user_data = <<-EOF
  #!/bin/bash
  sudo hostnamectl set-hostname "master"
  sudo amazon-linux-extras install -y epel
  sudo useradd rajith
  echo -e 'rajith\nrajith' | sudo passwd rajith
  echo 'rajith ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/devops
  sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  sudo systemctl restart sshd.service
  sudo yum install -y python3
  sudo yum install -y vim
  sudo sed -i -e '$a\'$'\n''172.16.10.100 master' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.101 node01' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.102 node02' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.103 node03' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.104 node04' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.10 Jumpserver' /etc/hosts
  EOF

  tags = {
    Name = "masternode"
  }
}


resource "aws_instance" "nodes" {
  count = 4
  ami = var.aws_ami_id
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.my_subnet.id
  private_ip = "172.16.10.${format(count.index+101)}"
  key_name = "testkey"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_sshweb.id]
  user_data = <<-EOF
  #!/bin/bash
  sudo hostnamectl set-hostname "node0${format(count.index+1)}"
  sudo amazon-linux-extras install -y epel
  sudo useradd rajith
  echo -e 'rajith\nrajith' | sudo passwd rajith
  echo 'rajith ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/devops
  sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  sudo systemctl restart sshd.service
  sudo yum install -y python3
  sudo yum install -y vim
  sudo sed -i -e '$a\'$'\n''172.16.10.100 master' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.101 node01' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.102 node02' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.103 node03' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.104 node04' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.10 Jumpserver' /etc/hosts
  EOF

  tags = {
    Name = "node0${format(count.index+1)}"
  }
}



#Execute the inital configuration to make the passwordless authenticati


resource "null_resource" "setuppasswordlessauth" {
 triggers = {
  always_run = "${timestamp()}"
 }

connection {
    type     = "ssh"
    user     = "rajith"
    password = "rajith"
    host     = aws_instance.Jumpserver.public_ip
  }

provisioner "remote-exec" {
  inline = [   
  "ansible-playbook -l nodes,master JumpServerConfig.yaml" ,
  "ansible-playbook -l nodes,master InititalSetup.yaml",
  "ansible-playbook -l master InitializetheMaster.yaml",
  "ansible-playbook -l nodes,master JoinTheNodesToK8s.yaml",
  "ansible-playbook -l master InstallCNI.yaml"
  

  ]
}

depends_on = [ aws_instance.nodes, aws_instance.master, aws_instance.Jumpserver ]

}
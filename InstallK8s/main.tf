
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
  sudo sed -i -e '$a\'$'\n''172.16.10.10 Jumpserver' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.51 node01' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.52 node02' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.53 node03' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.54 node04' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.55 node05' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.56 node06' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.57 node07' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.58 node08' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.59 node09' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.60 node10' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.61 node11' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.62 node12' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.63 node13' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.64 node14' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.65 node15' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.66 node16' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.67 node17' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.68 node18' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.69 node19' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.70 node20' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.71 node21' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.72 node22' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.73 node23' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.74 node24' /etc/hosts
  sudo sed -i -e '$a\'$'\n''172.16.10.75 node25' /etc/hosts
  
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

  tags = {
    Name = "jumpserver"
  }
}


#Create the master nodes

resource "aws_instance" "master" {
  count = 5
  ami = var.aws_ami_id
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.my_subnet.id
  private_ip = "172.16.10.${format(count.index+151)}"
  key_name = "testkey"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_sshweb.id]
  user_data = <<-EOF
  #!/bin/bash
  sudo hostnamectl set-hostname "master0${format(count.index+1)}"
  sudo amazon-linux-extras install -y epel
  sudo useradd rajith
  echo -e 'rajith\nrajith' | sudo passwd rajith
  echo 'rajith ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/devops
  sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  sudo systemctl restart sshd.service
  sudo yum install -y python3
  sudo yum install -y vim
  sudo sed -i -e '$a\'$'\n'   '"172.16.10.${format(count.index+151)}" "master0${format(count.index+1)}"' /etc/hosts
  EOF

  tags = {
    Name = "master0${format(count.index+1)}"
  }
}


#Execute the inital configuration to make the passwordless authenticati



#Create the worker nodes

resource "aws_instance" "worker" {
  count = 10
  ami = var.aws_ami_id
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.my_subnet.id
  private_ip = "172.16.10.${format(count.index+201)}"
  key_name = "testkey"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_sshweb.id]
  user_data = <<-EOF
  #!/bin/bash
  sudo hostnamectl set-hostname "worker0${format(count.index+1)}"
  sudo amazon-linux-extras install -y epel
  sudo useradd rajith
  echo -e 'rajith\nrajith' | sudo passwd rajith
  echo 'rajith ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/devops
  sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  sudo systemctl restart sshd.service
  sudo yum install -y python3
  sudo yum install -y vim
  sudo sed -i -e '$a\'$'\n'   '"172.16.10.${format(count.index+201)}" "master0${format(count.index+1)}"' /etc/hosts
  EOF

  tags = {
    Name = "worker0${format(count.index+1)}"
  }
}


#Execute the inital configuration to make the passwordless authenticati

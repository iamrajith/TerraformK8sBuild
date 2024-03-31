#Provider block is defined under the provider.tf file 

#VPC block 
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "MyVPC"
  }
}
#Subnet 1 
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2a"


  tags = {
    Name = "tf-example"
  }
}

#Subnet 2

resource "aws_subnet" "my_subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.20.0/24"
  availability_zone = "us-west-2b"


  tags = {
    Name = "tf-example"
  }
}


#Internet gateway 

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "main"
  }
}

#aws route table 

resource "aws_route_table" "myroutetable" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "myroutetable"
  }
}

#route table association
resource "aws_route_table_association" "myroutetableassociation" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.myroutetable.id
}

#Security group 

resource "aws_security_group" "allow_sshweb" {
  name        = "allow_ssh_web"
  description = "Allow ssh and web inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    description      = "Web from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    description      = "Cluster communication"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["172.16.10.0/24"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_sshWeb"
  }
}
variable "myregion" {
  description = "Please provide your aws region to create the resourse"
  #default = "us-west-2"
  default = "us-east-1"
}


variable "myaccesskey" {
  description = "Please enter your access key"
  default = "AKIAW5WU5NL4G5D3DG2R"
}

variable "mysecretkey" {
  description = "Please provide your secret key"
  default = "aDZiQcsCrIaJmgWvhC+cdhOP9Tl1cQhnUk32gMwf"
}


variable "aws_ami_id" {
  # Amazon Linux 2 AMI 
  #default = "ami-0944e91aed79c721c"
  default = "ami-0a1179631ec8933d7"

  }

variable "ssh_key_pair" {
  default = "~/.ssh/id_rsa"
  #default = "~/.ssh/id_rsa_ansilble_lab"
}

variable "ssh_key_pair_pub" {
  default = "~/.ssh/id_rsa.pub"
  #default = "~/.ssh/id_rsa_ansilble_lab.pub"
}

variable "ansible_node_count" {
  default = 2
}
variable "location" {
  default = "East US"
}

variable "resource_group_name" {
  default = "Unxettest_0606"
}

variable "admin_username" {
  default = "rajith"
}

variable "ssh_public_key" {
  default = "/c/Users/SG/.ssh/id_rsa.pub"
}

variable "node_count" {
  type = number
  default = 2
  
}
variable "admin_password" {
  type = string
  default = "Test@12345678"
}
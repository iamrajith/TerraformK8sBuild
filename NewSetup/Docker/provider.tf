terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {
  
  #variables are defined under variable.tf file 
  region = var.myregion
  access_key = var.myaccesskey
  secret_key = var.mysecretkey
  
  }
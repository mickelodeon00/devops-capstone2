# variables.tf

variable "region" {
  default = "eu-west-1"
}

variable "ami" {
  default = "ami-096f46d460613bed4"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  default = "mickey"
}

variable "db_username" {
  default = "cap2_admin"
}

variable "db_password" {
  description = "RDS password — set as GitHub secret, never hardcode"
  sensitive   = true
}
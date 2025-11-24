variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_az" {
  type    = string
  default = "ap-south-1a"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_subnet_az" {
  type    = string
  default = "ap-south-1b"
}

variable "AMI" {
  type    = string
  default = "ami-007020fd9c84e18c7"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "MyIP" {
  type    = string
  default = "117.99.192.124/32"
}
variable "aws_vpc" {
  type = object({
    name                 = string
    cidr_block           = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
    tags                 = map(string)
  })
}

variable "public_cidr_block" {
  type    = list(string)
  default = []
}

variable "private_cidr_block" {
  type    = list(string)
  default = []
}

variable "availability_zone" {
  type    = list(string)
  default = []
}

variable "create_nat_gateway" {
  type    = bool
  default = false
}
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
    default = [
        "10.0.1.0/24",
        "10.0.2.0/24"
    ]
     type    = list(string)
}

variable "private_cidr_block" {
    default = [
        # "10.0.11.0/24",
        # "10.0.22.0/24"
    ]
    type = list(string)
}

variable "availability_zone" {
    default = [
        "eu-west-2a",
        "eu-west-2b",
    ]
    type = list(string)
}

variable "create_nat_gateway" {
  type    = bool
  default = true
}
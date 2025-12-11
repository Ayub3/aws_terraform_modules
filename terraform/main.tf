module "vpc" {
  source = "./vpc"
  aws_vpc = {
    name                 = "${var.project}-${var.env}-vpc"
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
      env     = var.env
      project = "${var.project}-vpc"
    }
  }

  public_cidr_block  = ["10.0.0.0/24", "10.0.0.1/24"]
  private_cidr_block = ["10.0.0.128/24", "10.0.0.127/24"]
  availability_zone  = ["eu-west-2a", "eu-west-2b"]
  create_nat_gateway = true
}
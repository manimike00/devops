terraform {
  required_version = ">= 0.14"
}

module "vpc" {
    source = "./modules/vpc/"
    name    = var.name
    cidr_block = var.cidr_block
    subnets = 3
}
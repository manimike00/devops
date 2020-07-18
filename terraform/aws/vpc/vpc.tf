provider "aws" {
    region = "us-east-2"
}

data "aws_availability_zones" "main" {}

data "aws_region" "current" {}

locals {
  azs               = length(var.availability_zones) > 0 ? var.availability_zones : data.aws_availability_zones.main.names 
  nat_gateway_count = var.create_nat_gateways ? min(length(local.azs), length(var.public_subnet_cidrs), length(var.private_subnet_cidrs)) : 0
}

resource "aws_vpc" "main" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = true

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name_prefix}-vpc"
    },
  )
}

resource "aws_internet_gateway" "public" {
  count      = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  depends_on = [aws_vpc.main]
  vpc_id     = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name_prefix}-public-igw"
    },
  )
}

resource "aws_egress_only_internet_gateway" "outbound" {
  count      = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  depends_on = [aws_vpc.main]
  vpc_id     = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  count      = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  depends_on = [aws_vpc.main]
  vpc_id     = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name_prefix}-public-rt"
    },
  )
}

resource "aws_route" "public" {
  count = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  depends_on = [
    aws_internet_gateway.public,
    aws_route_table.public,
  ]
  route_table_id         = aws_route_table.public[0].id
  gateway_id             = aws_internet_gateway.public[0].id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "ipv6-public" {
  count = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  depends_on = [
    aws_internet_gateway.public,
    aws_route_table.public,
  ]
  route_table_id              = aws_route_table.public[0].id
  gateway_id                  = aws_internet_gateway.public[0].id
  destination_ipv6_cidr_block = "::/0"
}

resource "aws_subnet" "public" {
  count                           = length(var.public_subnet_cidrs)
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = var.public_subnet_cidrs[count.index]
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
  availability_zone               = element(local.azs, count.index)
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name_prefix}-public-subnet-${count.index + 1}"
      "Tier" = "Public"
    },
  )
}
# Configure the AWS Provider
provider "aws" {
  region  = "eu-west-2"
}

module "vpc" {

  source = "../"
  name = "vpc-example"
  cidr_block = "10.10.0.0/16"
  public_subnets = ["10.10.1.0/24","10.10.2.0/24","10.10.3.0/24"]
  internet_gateway = true
  nat_gateway = true
  azs = ["eu-west-2a","eu-west-2b", "eu-west-2c"]
}

module "envmap_vpc" {
  for_each = var.env_map

  source = "../"
  name = "envmap-example"
  cidr_block = each.value.cidr_block
  public_subnets = each.value.public_subnets
  internet_gateway = true
  azs = ["eu-west-2a","eu-west-2b", "eu-west-2c"]
}


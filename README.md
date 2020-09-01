# tf-aws-vps

Mostly intended as a lighter version of the aws-vpc module by Anton Babenko and for learning. Testing some approaches using tf 0.13 hcl language. (see example dir)

## Usage 

Example of passing params down the usual way 

```hcl
# Configure the AWS Provider
provider "aws" {
  region  = "eu-west-2"
}

# Passing config down the usual way
module "vpc" {

  source = "../"
  name = "vpc-example"
  cidr_block = "10.10.0.0/16"
  public_subnets = ["10.10.1.0/24","10.10.2.0/24","10.10.3.0/24"]
  internet_gateway = true
  nat_gateway = true
  azs = ["eu-west-2a","eu-west-2b", "eu-west-2c"]
}
```
Looping modules with for_each and a map 

```hcl
module "envmap_vpc" {
  for_each = var.env_map

  source = "../"
  name = "envmap-example"
  cidr_block = each.value.cidr_block
  public_subnets = each.value.public_subnets
  internet_gateway = true
  azs = ["eu-west-2a","eu-west-2b", "eu-west-2c"]
}
```
Example of map used in tfvars, all config in a single data structure 

```hcl
env_map = {
        dev = {
            cidr_block = "10.10.0.0/16"
            public_subnets = ["10.10.1.0/24","10.10.2.0/24","10.10.3.0/24"]
        },
        uat = {
            cidr_block = "10.10.0.0/16"
            public_subnets = ["10.10.1.0/24","10.10.2.0/24","10.10.3.0/24"]
        },
        perf = {
            cidr_block = "10.10.0.0/16"
            public_subnets = ["10.10.1.0/24","10.10.2.0/24","10.10.3.0/24"]
        }
}
```


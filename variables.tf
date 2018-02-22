#################
# VPC Variables
#################
variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  default     = true
}

variable "vpc_id" {
  default = ""
}

variable "name" {
  description = "VPC name"
  default = "vpc"
}

variable "cidr" {
  description = "CIDR range of the VPC"
  default = ""
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  default     = true
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  default     = []
}

variable "public_subnet_tags" {
  description = "Additional tags for the private subnets"
  default     = []
}


variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  default     = []
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  default     = []
}

variable "azs" {
  description = "A list of availability zones in the region"
  default     = []
}

# variable "private_subnets" {
#   description = "A list of private subnets inside the VPC"
#   default     = []
# }

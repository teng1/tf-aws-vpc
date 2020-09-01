#################
# VPC Variables
#################
variable "name" {
  description = "VPC name"
  default     = ""
}

variable "cidr_block" {
  description = "CIDR range of the VPC"
  default     = ""
}

variable "internet_gateway" {
  description = "Controls creation of an internet gateway"
  default = false
}
variable "azs" {
  description = "A list of availability zones in the region"
  default     = []
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  default     = true
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC"
  default     = false
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

variable "tags" {
  description = "Tags created for reseources created by the module"
  default = {}
}

variable "nat_gateway" {
  description = "enables nat gateway in private subnets"
  default = false
}

# variable "single_nat_gateway" {
#   description =  "use a single nat gateway set to false for ha"
#   default = false
# }

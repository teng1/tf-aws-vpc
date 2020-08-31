
# VPC
resource "aws_vpc" "vpc" {

  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = {
    Name = var.name
  }

}

resource "aws_eip" "eip" {
  count = length(var.azs)
  vpc   = true

  lifecycle {
     create_before_destroy = true 
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count = length(var.azs) > 0 ? length(var.azs) : 0

  allocation_id = element(aws_eip.eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)


  lifecycle {
    create_before_destroy = true
  }

  # depends_on = ["aws_eip.nat"]
}


# Public subnets
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.public_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  map_public_ip_on_launch = true


  lifecycle {
    create_before_destroy = true
  }

}
# Private subnets
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets)
  # vpc_id            = aws_vpc.vpc.*.id
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.azs, count.index)


  # tags {
  #    Name = var.name.element(var.azs, count.index).element(var.private_subnet_tags, count.index)
  # }

  lifecycle {
    create_before_destroy = true
  }

}

# Private routes
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  count  = length(var.private_subnets)

  route {
    cidr_block = "0.0.0.0/0"
    # nat_gateway_id = aws_nat_gateway.nat.*.id[count.index]
    nat_gateway_id = element(aws_nat_gateway.nat_gateway.*.id, count.index)
  }

  # tags { 
  #   Name = var.name.element(var.azs, count.index)
  # }

  lifecycle {
    create_before_destroy = true
  }

}


resource "aws_internet_gateway" "internet_gateway" {
  count = var.internet_gateway && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags
  )
}




resource "aws_route_table" "public_route_table" {
  count = length(var.public_subnets)
  
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_internet_gateway.internet_gateway.*.id, count.index)
  }

  # tags { Name = var.name}.${element(split(",", var.azs), count.index) }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.public_route_table.*.id, count.index)
}

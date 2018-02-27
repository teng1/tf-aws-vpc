
# VPC
resource "aws_vpc" "vpc" {
  count = "${var.create_vpc ? 1 : 0}"

  cidr_block           = "${var.cidr}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags      { Name = "${var.name}" }

}

# NAT gateway
resource "aws_eip" "nat" {
  count = "${length(var.azs)}"
  vpc   = true

  lifecycle { create_before_destroy = true }
}

resource "aws_nat_gateway" "nat" {
  count = "${var.create_vpc && length(var.azs) > 0 ? length(var.azs) : 0}"

  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"


  lifecycle { create_before_destroy = true }
  # depends_on = ["aws_eip.nat"]
}

# Private subnets
resource "aws_subnet" "private" {
  count = "${var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"
# vpc_id            = "${aws_vpc.vpc.*.id}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(var.private_subnets, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"


  tags      { Name = "${var.name}.${element(var.azs, count.index)}.${element(var.private_subnet_tags, count.index)}" }
  lifecycle { create_before_destroy = true }
}

# Private routes
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  count  = "${length(var.private_subnets)}"

  route {
    cidr_block     = "0.0.0.0/0"
    # nat_gateway_id = "${aws_nat_gateway.nat.*.id[count.index]}"
    nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  }

  tags      { Name = "${var.name}.${element(var.azs, count.index)}" }
  lifecycle { create_before_destroy = true }

}


resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags { Name = "${var.name}" }
}

# Public subnets
resource "aws_subnet" "public" {
  count             = "${length(var.public_subnets)}"

  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(var.public_subnets, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"


  # tags      { Name = "${var.name}.${element(split(",", var.azs), count.index)}" }
  lifecycle { create_before_destroy = true }

  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.public.id}"
  }

  # tags { Name = "${var.name}.${element(split(",", var.azs), count.index)}" }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

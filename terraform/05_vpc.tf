resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-vpc"
    )
  )}"
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-igw"
    )
  )}"
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-rtb"
    )
  )}"
}

resource "aws_route" "default" {
  route_table_id = "${aws_route_table.main.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.main.id}"
}

resource "aws_subnet" "public-a" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet1_cidr}"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-sn-pub-1"
    )
  )}"
}

resource "aws_route_table_association" "public-a" {
  subnet_id = "${aws_subnet.public-a.id}"
  route_table_id = "${aws_route_table.main.id}"
}

resource "aws_subnet" "public-b" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet2_cidr}"
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-sn-pub-2"
    )
  )}"
}

resource "aws_route_table_association" "public-b" {
  subnet_id = "${aws_subnet.public-b.id}"
  route_table_id = "${aws_route_table.main.id}"
}

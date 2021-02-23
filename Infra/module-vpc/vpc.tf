#vpc
variable "region" {}
variable "azs_list" {type="list"}
variable "vpc-cidr" {}
variable "public_subnet" {}
variable "private_subnet" {}
## EIP
#resource "aws_eip" "eip-wordpress" {
#  vpc = true
#}

resource "aws_vpc" "vpc-wordpress" {
  cidr_block = "${var.vpc-cidr}"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  enable_classiclink_dns_support = "false"
  tags = {
      Name = "vpc-wordpress"
  }
}

#IG and attached to VPC
resource "aws_internet_gateway" "ig-wordpress" {
   vpc_id = "${aws_vpc.vpc-wordpress.id}"
   tags = {
     Name = "ig-wordpress"
   }
}

## NAT Gateway
#resource "aws_nat_gateway" "nat-gw-wordpress" {
#  allocation_id = "${aws_eip.eip-wordpress.id}"
#  subnet_id = "${aws_subnet.subnet-pub-wordpress.id}"
#  depends_on = ["aws_internet_gateway.ig-wordpress"]
#}


#Route table creation, attach to VPC & allow traffic through NAT Gatway
#resource "aws_route_table" "rt-pri-wordpress" {
#  vpc_id = "${aws_vpc.vpc-wordpress.id}"
#  route {
#    cidr_block = "0.0.0.0/0"
#    nat_gateway_id = "${aws_nat_gateway.nat-gw-wordpress.id}"
#  }
#  tags = {
#    Name = "rt-pri-wordpress"
#  }
#} 
#Route table creation, attach to VPC & allow traffic b/w vpc & IG
resource "aws_route_table" "rt-pub-wordpress" {
  vpc_id = "${aws_vpc.vpc-wordpress.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig-wordpress.id}"
  }
  tags = {
    Name = "rt-pub-wordpress"
  }
} 

##Private subnet
resource "aws_subnet" "subnet-pri-wordpress" {
  vpc_id = "${aws_vpc.vpc-wordpress.id}"
  cidr_block = "${var.private_subnet}"
  map_public_ip_on_launch = "false"
  availability_zone = "${element(var.azs_list,0)}"
  tags = {
    Name = "subnet-pri-wordpress"
  }
}

## Public subnet
resource "aws_subnet" "subnet-pub-wordpress" {
  vpc_id = "${aws_vpc.vpc-wordpress.id}"
  cidr_block = "${var.public_subnet}"
  map_public_ip_on_launch = "true"
  availability_zone = "${element(var.azs_list,1)}"
  tags = {
    Name = "subnet-pub-wordpress"
  }
}

## Route associations public subnet

resource "aws_route_table_association" "rt-ass-pub-wordpress" {
  subnet_id = "${aws_subnet.subnet-pub-wordpress.id}"
  route_table_id = "${aws_route_table.rt-pub-wordpress.id}"
}

## Route associations private subnet
#resource "aws_route_table_association" "rt-ass-pri-wordpress" {
#  subnet_id = "${aws_subnet.subnet-pri-wordpress.id}"
#  route_table_id = "${aws_route_table.rt-pri-wordpress.id}"
#}


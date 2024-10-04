data "aws_availability_zones" "availability_zones" {}


resource "aws_vpc" "eksclustervpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      name = "${var.PROJECT_NAME}-VPC"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.eksclustervpc.id


    tags = {
      name = "${var.PROJECT_NAME}-IGW"
    }
  
}

resource "aws_subnet" "pub_sub1" {
  vpc_id = aws_vpc.eksclustervpc.id
  cidr_block = var.PUB_SUB1_CIDR
  map_public_ip_on_launch = true
   availability_zone         = data.aws_availability_zones.availability_zones.names[0]



  tags = {
    name = "pub-sub-1"
    "kubernetes.io/cluster/${var.PROJECT_NAME}" = "shared"
    "kubernetes.io/role/internal-elb" = 1

  }
}

resource "aws_subnet" "pub_sub2" {
  vpc_id = aws_vpc.eksclustervpc.id
  
  cidr_block = var.PUB_SUB2_CIDR
  map_public_ip_on_launch = true
  availability_zone         = data.aws_availability_zones.availability_zones.names[1]



  tags = {
    name = "pub-sub-2"
    "kubernetes.io/cluster/${var.PROJECT_NAME}" = "shared"
    "kubernetes.io/role/internal-elb" = 1

  }
}

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.eksclustervpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    name = "public-route-table"
  }
}

resource "aws_route_table_association" "pub-sub1-rt" {
  route_table_id = aws_route_table.pub-rt.id
  subnet_id = aws_subnet.pub_sub1.id
}

resource "aws_route_table_association" "pub-sub2-rt" {
  route_table_id = aws_route_table.pub-rt.id
  subnet_id = aws_subnet.pub_sub2.id
}

resource "aws_subnet" "pri_sub3" {
    vpc_id = aws_vpc.eksclustervpc.id
    cidr_block = var.PRI_SUB3_CIDR
     availability_zone         = data.aws_availability_zones.availability_zones.names[0]

    map_public_ip_on_launch = false

    tags = {
      name = "pri-sub-3"
      "kubernetes.io/cluster/${var.PROJECT_NAME}" = "shared"
      "kubernetes.io/role/internal-elb" = 1
    }
}

resource "aws_subnet" "pri_sub4" {
    vpc_id = aws_vpc.eksclustervpc.id
    cidr_block = var.PRI_SUB4_CIDR
    availability_zone         = data.aws_availability_zones.availability_zones.names[1]

    map_public_ip_on_launch = false

    tags = {
      name = "pri-sub-4"
      "kubernetes.io/cluster/${var.PROJECT_NAME}" = "shared"
      "kubernetes.io/role/internal-elb" = 1
    }
}


#Create a new VPC
resource "aws_vpc" "vpc_k8s-cka" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "k8s-cka-vpc"
  }
}

#Get all available AZ's for the region.
data "aws_availability_zones" "azs" {
  state = "available"
}

#Create subnets.
resource "aws_subnet" "subnet1" {
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_k8s-cka.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "k8s-cka-subnet"
  }
}

resource "aws_subnet" "subnet2" {
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc_k8s-cka.id
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "k8s-cka-subnet"
  }
}

#Create the IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_k8s-cka.id
}

#Get main route table to modify
data "aws_route_table" "main_route_table" {
  filter {
    name   = "association.main"
    values = ["true"]
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc_k8s-cka.id]
  }
}

#Create route table
resource "aws_default_route_table" "internet_route" {
  default_route_table_id = data.aws_route_table.main_route_table.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "k8s-cka-route_table"
  }
}

#Create SG for the instances
resource "aws_security_group" "sg_ec2" {
  name        = "k8s-cka-sg_ec2"
  description = "Allow TCP/22"
  vpc_id      = aws_vpc.vpc_k8s-cka.id
  ingress {
    description = "Allow 22 from the public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow everything inside the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "k8s-cka-sg"
  }
}
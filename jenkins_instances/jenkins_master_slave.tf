variable "access_key" {
  default="AKIAIVL6CPRLCBLIQMAA"
}

variable "secret_key" {
  default="grbi6MAKImjVaS3V8X/F6vJ2wvzMj3/9yFdDn3+6"
}

variable "nameKey"{
  default="keypair_aws"
}

variable "private_key_path" {
  default  = "jenkins_instances/keypair_aws.pem"
}

variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}

variable "private_subnet_cidr_block" {
  default     = "10.0.0.0/24"
  type        = string
  description = "private subnet CIDR blocks"
}

variable "public_subnet_cidr_block" {
  default     = "10.0.1.0/24"
  type        = string
  description = "public subnet CIDR blocks"
}

variable "availability_zone" {
  default     = ["eu-west-2a","eu-west-2b","eu-west-2c"]
  type        = list
  description = "availability zone"
}

provider "aws" {
  region = "eu-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_ami" "packer_image_master" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Jenkins-master-image-Packer"]
  }
   owners = ["self"]
}

data "aws_ami" "packer_image_slave" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Jenkin-slave-image-Packer"]
  }
   owners = ["self"]
}

resource "aws_vpc" "jenkinsvpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "private" {

  vpc_id            = aws_vpc.jenkinsvpc.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = var.availability_zone[0]
  }

resource "aws_subnet" "public" {

  vpc_id                  = aws_vpc.jenkinsvpc.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.availability_zone[1]
  map_public_ip_on_launch = true
}

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.jenkinsvpc.id
}

resource "aws_internet_gateway" "gwvpc" {
  vpc_id = aws_vpc.jenkinsvpc.id
}

resource "aws_route" "private" {

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
 }

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.jenkinsvpc.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gwvpc.id
}

resource "aws_route_table_association" "private" {

  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {

  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "jenkinsMaster-sg" {
  name              = "jenkins&nexus-sg"
  vpc_id = aws_vpc.jenkinsvpc.id
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 50000
    to_port         = 50000
    protocol        = "tcp"
    cidr_blocks     = ["${var.cidr_block}"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_master" {
  ami               = data.aws_ami.packer_image_master.id
  instance_type     = "t2.medium"
  key_name          = var.nameKey
  vpc_security_group_ids = ["${aws_security_group.jenkinsMaster-sg.id}"]
  tags = {
    Name            = "jenkins_master"
  }
  subnet_id = aws_subnet.private.id
}

resource "aws_eip" "eip-master" {
  instance = aws_instance.jenkins_master.id
  vpc = true
}

resource "aws_security_group" "jenkinsSlave-sg" {
  name              = "jenkinsSlave-sg"
  vpc_id = aws_vpc.jenkinsvpc.id
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_slave" {
  ami               = data.aws_ami.packer_image_slave.id
  instance_type     = "t2.micro"
  key_name          = var.nameKey
  vpc_security_group_ids = ["${aws_security_group.jenkinsSlave-sg.id}"]
  tags = {
    Name            = "jenkins_slave"
  }
  subnet_id = aws_subnet.private.id
}

resource "aws_eip" "eip-slave" {
  instance = aws_instance.jenkins_slave.id
  vpc = true
}

resource "aws_eip" "nateip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  depends_on = [aws_internet_gateway.gwvpc]

  allocation_id = aws_eip.nateip.id
  subnet_id     = aws_subnet.public.id
}
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
  default  = "C:/packer/aws/Packer_terraform/keypair_aws.pem"
}


provider "aws" {
  region = "eu-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_ami" "packer_image_jenkins" {
  most_recent = true
  filter {
    name   = "name"
    values = ["jenkins-image-Packer"]
  }
   owners = ["self"]
}

resource "aws_security_group" "jenkins-sg" {
  name              = "jenkins&nexus-sg"
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 50000
    to_port         = 50000
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    description       = "jenkins server JNLP Connection"
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
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_machine" {
  ami               = data.aws_ami.packer_image_jenkins.id
  instance_type     = "t2.medium"
  key_name          = var.nameKey
  subnet_id = "subnet-56af3c2c"
  private_ip = "172.31.16.10"
  vpc_security_group_ids = ["${aws_security_group.jenkins-sg.id}"]
  tags = {
    Name            = "jenkins_machine"
  }
  associate_public_ip_address = true
}
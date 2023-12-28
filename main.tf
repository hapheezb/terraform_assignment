terraform {
    required_version = "~> 1.0"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}


provider "aws" {
    region = var.region
}


terraform {
  backend "s3" {
    bucket = "tf-bucket44"
    key    = "terraform_assignment/terraform.tfstate"
    dynamodb_table = "terraform_lock"
    region = "us-west-2"
  }
}


resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "mainVPC"
  }
}


resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet1_cidr
  availability_zone = "${var.region}a"
  
  tags = {
    Name = "Subnet1"
  }
}


resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet2_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "Subnet2"
  }
}


data "aws_ami" "amazon_linux" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}


resource "aws_instance" "instance1" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet1.id
  security_groups = [aws_security_group.sg1.id]
  key_name = var.key_pair
  associate_public_ip_address = true
  
  tags = {
    Name = "Instance1_tf"
  }
}


resource "aws_instance" "instance2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet2.id
  security_groups = [aws_security_group.sg2.id]
  key_name = var.key_pair
  associate_public_ip_address = true

  tags = {
    Name = "Instance2_tf"
  }

}


resource "aws_security_group" "sg1" {
  name        = "SG1"
  description = "Security group for Instance 1"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
  }

 tags = {
   Name = "SG1"
 }
}


resource "aws_security_group" "sg2" {
  name        = "SG2"
  description = "Security group for Instance 2"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = {
    Name = "SG2"
  }

}



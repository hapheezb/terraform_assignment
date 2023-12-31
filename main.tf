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
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "mainVPC"
  }
}


resource "aws_subnet" "subnet" {
  count = var.subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone = var.availability_zone
  
  tags = {
    Name = "Subnet-${count.index}"
    count = "{count.index}"
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


resource "aws_instance" "instance" {
  count = var.instance_count
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  #subnet_id     = aws_subnet.subnet[count.index].id
  subnet_id     = aws_subnet.subnet[count.index % var.subnet_count].id
  security_groups = [aws_security_group.allow_http.id]
  key_name = var.key_pair
  associate_public_ip_address = true
  
  tags = {
    Name = "Instance-${count.index}"
    count = "${count.index}"
  }
}



resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = range(var.instance_count)

    content {
      from_port = contains(var.ingress_port_80_instances, ingress.key) ? 80 : 8080
      to_port   = contains(var.ingress_port_80_instances, ingress.key) ? 80 : 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
   
  }
  
}

resource "aws_dynamodb_table" "tf_lock" {
  name = "terraform_lock"
  hash_key = "LockID"
  read_capacity = 3
  write_capacity = 3
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform_lock_table"
  }

  lifecycle {
    prevent_destroy = false
  }
}




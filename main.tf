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
  for_each = {
    for idx in range(var.subnet_count): idx => {
      cidr_block = "10.0.${idx}.0/24"
    }
  }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = var.availability_zone
  #map_public_ip_on_launch = true
  
  tags = {
    Name = "subnet-${each.key}"
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
  for_each = aws_subnet.subnet
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = each.value.id
  security_groups = [aws_security_group.allow_http.id]
  key_name = var.key_pair
  associate_public_ip_address = true
  
  tags = {
    Name = "instance-${each.key}"
    subnet = each.key
  }
}



resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = {
      for idx in range(2): idx => {
        port = idx == 0 ? 80 : 8080
      }
    }

    content {
      from_port = ingress.value.port
      to_port   = ingress.value.port
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




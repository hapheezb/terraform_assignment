variable "region" {
  description = "AWS region to launch resources in."
  type = string
  default     = "us-west-2" 
}

variable "instance_type" {
  description = "AWS ec2 instance type."
  type = string
  default     = "t2.micro" 
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/20"
}

variable "subnet1_cidr" {
  description = "CIDR block for Subnet 1."
  default     = "10.0.1.0/24"
}

variable "subnet2_cidr" {
  description = "CIDR block for Subnet 2."
  default     = "10.0.2.0/24"
}

variable "key_pair" {
  description = "AWS ec2 key pair."
  type = string
  default     = "terraform_key" 
}


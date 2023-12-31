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
  type = string
  default     = "10.0.0.0/20"
}

variable "subnet_count" {
  description = "Number of subnets to create."
  type = number
  default     = 2
}

variable "instance_count" {
  description = "Number of instances to create."
  type = number
  default     = 2
}

variable "availability_zone" {
  description = "Availability zone for the subnets."
  type = string
  default     = "us-west-2a"
}

variable "key_pair" {
  description = "AWS ec2 key pair."
  type = string
  default     = "terraform_key" 
}

variable "ingress_port_80_instances" {
  description = "List of instance indices to open port 80."
  type = list(number)
  default     = [0]
  
}

variable "ingress_port_8080_instances" {
  description = "List of instance indices to open port 8080."
  type = list(number)
  default     = [1]
  
}




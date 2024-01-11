output "instance_public_ips" {
  description = "Public IP address of the EC2 Instances"
  value       = [for instance in aws_instance.instance: instance.public_ip]
}



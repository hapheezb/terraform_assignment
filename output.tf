output "instance_public_ips" {
  description = "Public IP address of the EC2 Instances"
  value       = aws_instance.instance[*].public_ip
}



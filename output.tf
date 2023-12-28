output "instance1_public_ip" {
  description = "Public IP address of the EC2 Instance1_tf"
  value       = aws_instance.instance1.public_ip
}


output "instance2_public_ip"  {
  description = "Public IP address of the EC2 Instance2_tf"
  value       = aws_instance.instance2.public_ip
}
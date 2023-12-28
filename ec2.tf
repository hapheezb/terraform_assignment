resource "aws_instance" "instance1" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  user_data = file("${path.module}/app1-install.sh")
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
  user_data = file("${path.module}/app2-install.sh")
  subnet_id     = aws_subnet.subnet2.id
  security_groups = [aws_security_group.sg2.id]
  key_name = var.key_pair
  associate_public_ip_address = true

  tags = {
    Name = "Instance2_tf"
  }

}

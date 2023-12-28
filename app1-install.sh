#! /bin/bash

sudo yum update -y
sudo yum install httpd -y
sudo systemctl enable httpd
sudo service httpd start
sudo echo "<h1>Deployed via Terraform for Instance 1</h1>" | sudo tee /var/www/html/index.html
sudo mkdir /var/www/html/app1
sudo echo "<!DOCTYPE html> <html> <body style='background-color:rgb(250, 210, 210);"> <h1>Create a VPC with 2 subnets, create an instance in subnet 1, another instance 2 in subnet2. <br>Create a security group to allow internet traffic on port 80 on instance 1 and for the other on port 8080</h1> <p>Terraform Demo</p> </body> </html>" | sudo tee /var/www/html/app1/index.html
sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html
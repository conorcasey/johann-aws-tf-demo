# ---------------------------------------------------------------------------------------------------------------------
# DEFIINE SUPPORTED TERRAFORM VERSIONS
# Define which versions of terraform this configuration supports
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.13"
}


# ---------------------------------------------------------------------------------------------------------------------
# INCLUDE THE AWS PROVIDER
# The aws provider will be leveraged to provision aws resources
# https://www.terraform.io/docs/providers/aws/index.html
# ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE RESOURCES
# Create a simple application environment comprising of an ELB with some attached EC2 instances, an RDS database, and
# all supporting network resources
# ---------------------------------------------------------------------------------------------------------------------

# Create EC2 instances
resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  user_data = <<EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install nginx -y
    sudo service nginx start
    sudo chkconfig nginx on
  EOF

  tags = {
    Name = format("%s%d", var.ec2_instance_name, count.index+1)
  }
}


# Create Elastic Load Balancer
resource "aws_elb" "elb" {
  name               = var.elb_name
  subnets            = [var.subnet_id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = aws_instance.web.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
     Name = var.elb_name
  }
}


# Create RDS database
resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  tags = {
    Name = "demodb"
  }
}

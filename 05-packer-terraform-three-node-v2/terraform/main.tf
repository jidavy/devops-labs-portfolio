terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Tells Terraform which cloud and region to talk to
provider "aws" {
  region = var.region
}

# Look up the default VPC (the network every AWS account already has)
data "aws_vpc" "default" {
  default = true
}

# Upload your public key so you can SSH in
# Look up the key pair that already exists in AWS (we don't create or delete it)

data "aws_key_pair" "dev" {
  key_name = "dev_key"
}

# ---------- Security groups (firewalls) ----------

# Frontend: the world can reach the website on port 80
resource "aws_security_group" "frontend" {
  name        = "fruits-frontend-sg-v2"
  description = "Allow HTTP and SSH to the Nginx node"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Backends: ports 8080 (Python) and 9090 (Java) are open because
# the visitor's browser calls the backends directly
resource "aws_security_group" "backend" {
  name        = "fruits-backend-sg-v2"
  description = "Allow app ports and SSH to the backend nodes"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------- Node 2: Python backend on 8080 ----------
resource "aws_instance" "python" {
  ami                         = var.backend_ami_id
  instance_type               = var.instance_type
  key_name                    = data.aws_key_pair.dev.key_name
  vpc_security_group_ids      = [aws_security_group.backend.id]
  associate_public_ip_address = true

  # Runs once at first boot, as root
  user_data = <<-EOF
    #!/bin/bash
    cd /opt/fruits-veg_market/python
    setsid nohup .venv/bin/uvicorn main:app --host 0.0.0.0 --port 8080 > /var/log/fruits.log 2>&1 &
  EOF

  tags = { Name = "tf-python-backend" }
}

# ---------- Node 3: Java backend on 9090 ----------
resource "aws_instance" "java" {
  ami                         = var.backend_ami_id
  instance_type               = var.instance_type
  key_name                    = data.aws_key_pair.dev.key_name
  vpc_security_group_ids      = [aws_security_group.backend.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    cd /opt/fruits-veg_market/java
    setsid nohup java -jar target/produce-app-0.0.1-SNAPSHOT.jar --server.address=0.0.0.0 --server.port=9090 > /var/log/vegetables.log 2>&1 &
  EOF

  tags = { Name = "tf-java-backend" }
}

# ---------- Node 1: Nginx frontend ----------
# It refers to the two backends' IPs, so Terraform creates them first
resource "aws_instance" "nginx" {
  ami                         = var.nginx_ami_id
  instance_type               = var.instance_type
  key_name                    = data.aws_key_pair.dev.key_name
  vpc_security_group_ids      = [aws_security_group.frontend.id]
  associate_public_ip_address = true

  # Same sed as Week 4, now with the new ports (8080 and 9090),
  # then start Nginx
  user_data = <<-EOF
    #!/bin/bash
    sed -i "s/FRUIT_MACHINE:9000/${aws_instance.python.public_ip}:8080/; s/VEG_MACHINE:8080/${aws_instance.java.public_ip}:9090/" /usr/share/nginx/html/index.html
    systemctl start nginx
  EOF

  tags = { Name = "tf-nginx-frontend" }
}
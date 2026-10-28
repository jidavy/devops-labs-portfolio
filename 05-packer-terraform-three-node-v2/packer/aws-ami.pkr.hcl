# Tells Packer which plugin to download (the AWS builder)
packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# A timestamp so every build gets a unique AMI name (AMI names must be unique)
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

# --- Source 1: temporary EC2 instance used to build the Nginx image ---
source "amazon-ebs" "nginx" {
  region        = "eu-west-2"
  instance_type = "t3.micro"
  ssh_username  = "ec2-user" # default login user on Amazon Linux
  ami_name      = "fruits-nginx-${local.timestamp}"

  # Find the newest official Amazon Linux 2023 image to start from
  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023.*-x86_64"
      virtualization-type = "hvm"
    }
    owners      = ["amazon"]
    most_recent = true
  }

  tags = { Name = "fruits-nginx" }
}

# --- Source 2: same idea, for the backend image ---
source "amazon-ebs" "backend" {
  region        = "eu-west-2"
  instance_type = "t3.small" # Maven builds need a bit more memory than t3.micro
  ssh_username  = "ec2-user"
  ami_name      = "fruits-backend-${local.timestamp}"

  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023.*-x86_64"
      virtualization-type = "hvm"
    }
    owners      = ["amazon"]
    most_recent = true
  }

  tags = { Name = "fruits-backend" }
}

# --- Build 1: AMI-1 (Nginx frontend) ---
build {
  name    = "nginx"
  sources = ["source.amazon-ebs.nginx"]

  provisioner "shell" {
    script          = "scripts/nginx-setup.sh"
    execute_command = "sudo -E bash '{{ .Path }}'" # run the script as root
  }
}

# --- Build 2: AMI-2 (Java 17 + Python 3 backend) ---
build {
  name    = "backend"
  sources = ["source.amazon-ebs.backend"]

  provisioner "shell" {
    script          = "scripts/backend-setup.sh"
    execute_command = "sudo -E bash '{{ .Path }}'"
  }
}
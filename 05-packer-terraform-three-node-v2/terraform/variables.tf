variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "eu-west-2"
}

variable "nginx_ami_id" {
  description = "AMI built by Packer for the Nginx frontend"
  type        = string
  default     = "ami-0ba89ca77af5d8da3"
}

variable "backend_ami_id" {
  description = "AMI built by Packer for the Python/Java backends"
  type        = string
  default     = "ami-03184ada10c8a8a94"
}

variable "instance_type" {
  description = "Size of each server"
  type        = string
  default     = "t3.micro"
}

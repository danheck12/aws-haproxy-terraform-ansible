variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "haproxy-lab"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ssh_key_name" {
  description = "Existing EC2 Key Pair name to attach for SSH"
  type        = string
}

variable "admin_cidr" {
  description = "CIDR allowed to SSH (your public IP/32)"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.10.1.0/24"
}

variable "ubuntu_ami_owner" {
  description = "Canonical owner ID for Ubuntu AMIs"
  type        = string
  default     = "099720109477"
}

variable "ubuntu_ami_name" {
  description = "Ubuntu AMI name pattern"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

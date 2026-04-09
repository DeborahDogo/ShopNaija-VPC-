variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-west-1"
}

variable "vpc_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "shopnaija-vpc"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-west-1a", "us-west-1c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private app subnets"
  type        = list(string)
  default     = ["10.0.10.0/23", "10.0.12.0/23"]
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway to save cost"
  type        = bool
  default     = true
}

variable "one_nat_gateway_per_az" {
  description = "Deploy one NAT Gateway per AZ for full HA"
  type        = bool
  default     = false
}

variable "bastion_ami" {
  description = "AMI ID for the Bastion Host"
  type        = string
}

variable "bastion_instance_type" {
  description = "EC2 instance type for Bastion"
  type        = string
  default     = "t3.micro"
}

variable "bastion_key_name" {
  description = "Name of the SSH key pair in AWS"
  type        = string
}

variable "devops_ip_whitelist" {
  description = "IP addresses allowed to SSH into the Bastion"
  type        = list(string)
}


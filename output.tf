output "vpc_id" {
  description = "VPC ID"
  value       = module.shopnaija_vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.shopnaija_vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.shopnaija_vpc.public_subnets
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.shopnaija_vpc.private_subnets
}

output "database_subnet_ids" {
  description = "Database subnet IDs"
  value       = module.shopnaija_vpc.database_subnets
}

output "database_subnet_group_name" {
  description = "RDS subnet group name"
  value       = module.shopnaija_vpc.database_subnet_group_name
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.shopnaija_vpc.igw_id
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = module.shopnaija_vpc.natgw_ids
}

output "nat_gateway_public_ips" {
  description = "NAT Gateway public IPs — whitelist these with external APIs"
  value       = module.shopnaija_vpc.nat_public_ips
}

output "bastion_public_ip" {
  description = "Bastion Host public IP"
  value       = aws_instance.bastion.public_ip
}

output "bastion_ssh_command" {
  description = "SSH command to connect to Bastion"
  value       = "ssh -i ~/.ssh/${var.bastion_key_name}.pem ec2-user@${aws_instance.bastion.public_ip}"
}

output "bastion_security_group_id" {
  description = "Bastion security group ID"
  value       = aws_security_group.bastion_sg.id
}

output "app_security_group_id" {
  description = "App server security group ID"
  value       = aws_security_group.app_sg.id
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb_sg.id
}

output "database_security_group_id" {
  description = "Database security group ID"
  value       = aws_security_group.db_sg.id
}


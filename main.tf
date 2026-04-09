module "shopnaija_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs              = var.availability_zones
  public_subnets   = var.public_subnet_cidrs
  private_subnets  = var.private_subnet_cidrs
  database_subnets = var.database_subnet_cidrs

  enable_nat_gateway     = true
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  tags = local.common_tags

  public_subnet_tags = {
    Type = "Public"
    Tier = "Web"
  }

  private_subnet_tags = {
    Type = "Private"
    Tier = "Application"
  }

  database_subnet_tags = {
    Type = "Private"
    Tier = "Database"
  }
}

resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami
  instance_type               = var.bastion_instance_type
  subnet_id                   = module.shopnaija_vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = var.bastion_key_name
  associate_public_ip_address = true

  tags = merge(local.common_tags, {
    Name = "${var.vpc_name}-bastion"
    Role = "BastionHost"
  })
}

resource "aws_security_group" "bastion_sg" {
  name        = "${var.vpc_name}-bastion-sg"
  description = "Allow SSH from DevOps team only"
  vpc_id      = module.shopnaija_vpc.vpc_id

  ingress {
    description = "SSH from DevOps"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.devops_ip_whitelist
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.vpc_name}-bastion-sg" })
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.vpc_name}-alb-sg"
  description = "Allow HTTP and HTTPS from internet"
  vpc_id      = module.shopnaija_vpc.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.vpc_name}-alb-sg" })
}

resource "aws_security_group" "app_sg" {
  name        = "${var.vpc_name}-app-sg"
  description = "Allow traffic from ALB and SSH from Bastion"
  vpc_id      = module.shopnaija_vpc.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "HTTPS from ALB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.vpc_name}-app-sg" })
}

resource "aws_security_group" "db_sg" {
  name        = "${var.vpc_name}-db-sg"
  description = "Allow DB connections from app servers only"
  vpc_id      = module.shopnaija_vpc.vpc_id

  ingress {
    description     = "PostgreSQL from App servers"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(local.common_tags, { Name = "${var.vpc_name}-db-sg" })
}


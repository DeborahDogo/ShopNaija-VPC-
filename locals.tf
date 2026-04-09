locals {
  common_tags = {
    Project     = "ShopNaija"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "DevOps"
    Region      = var.aws_region
  }
}

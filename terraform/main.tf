terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Repository  = "StartTech-infra"
    }
  }
}

# Create VPC and Networking
module "networking" {
  source = "./modules/networking"
  
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  project_name         = var.project_name
  environment          = var.environment
}

# Create ECR Repository for backend
module "ecr" {
  source = "./modules/storage"
  
  project_name = var.project_name
  environment  = var.environment
  create_ecr   = true
  create_s3    = false
}

# Create S3 Bucket for frontend
module "s3_frontend" {
  source = "./modules/storage"
  
  project_name = var.project_name
  environment  = var.environment
  create_ecr   = false
  create_s3    = true
  bucket_name  = var.s3_bucket_name
}

# Create Compute Resources (EC2, ALB, Auto Scaling)
module "compute" {
  source = "./modules/compute"
  
  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  instance_type      = var.instance_type
  min_size           = var.min_size
  max_size           = var.max_size
  desired_capacity   = var.desired_capacity
  ecr_repository_url = module.ecr.ecr_repository_url
}

# Create CloudFront Distribution
module "cloudfront" {
  source = "./modules/networking"
  
  project_name       = var.project_name
  environment        = var.environment
  create_cloudfront  = true
  s3_bucket_id       = module.s3_frontend.s3_bucket_id
  s3_bucket_domain   = module.s3_frontend.s3_bucket_domain
}

# Create ElastiCache Redis
module "redis" {
  source = "./modules/compute"
  
  project_name          = var.project_name
  environment           = var.environment
  create_redis          = true
  vpc_id                = module.networking.vpc_id
  private_subnet_ids    = module.networking.private_subnet_ids
  redis_node_type       = var.redis_node_type
  redis_num_cache_nodes = var.redis_num_cache_nodes
}

# Create Monitoring Resources
module "monitoring" {
  source = "./modules/monitoring"
  
  project_name            = var.project_name
  environment             = var.environment
  alb_arn                 = module.compute.alb_arn
  auto_scaling_group_name = module.compute.auto_scaling_group_name
  ec2_instance_id         = module.compute.ec2_instance_id
}

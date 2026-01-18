# AWS Configuration
aws_region = "eu-west-1"

# Application Configuration
project_name = "starttech"
environment  = "production"

# Network Configuration
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones   = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

# Compute Configuration
instance_type     = "t3.micro"
min_size          = 2
max_size          = 5
desired_capacity  = 2

# Redis Configuration
redis_node_type       = "cache.t3.micro"
redis_num_cache_nodes = 1

# S3 Bucket Name (YOUR ACTUAL BUCKET NAME)
s3_bucket_name = "starttech-frontend-Ermias-1072-app"

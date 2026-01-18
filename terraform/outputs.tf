output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.compute.alb_dns_name
}

output "s3_bucket_name" {
  description = "S3 bucket name for frontend"
  value       = module.s3_frontend.s3_bucket_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.cloudfront.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = module.cloudfront.cloudfront_domain_name
}

output "redis_endpoint" {
  description = "Redis ElastiCache endpoint"
  value       = module.redis.redis_endpoint
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.ecr_repository_url
}

output "ec2_security_group_id" {
  description = "EC2 security group ID"
  value       = module.compute.ec2_security_group_id
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group name"
  value       = module.monitoring.cloudwatch_log_group_name
}

output "availability_zones" {
  description = "Availability zones used"
  value       = var.availability_zones
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.networking.private_subnet_ids
}

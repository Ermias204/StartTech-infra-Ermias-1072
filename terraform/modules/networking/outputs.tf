output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = var.create_cloudfront ? aws_cloudfront_distribution.s3_distribution[0].id : ""
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = var.create_cloudfront ? aws_cloudfront_distribution.s3_distribution[0].domain_name : ""
}

output "cloudfront_origin_access_identity" {
  description = "CloudFront OAI"
  value       = var.create_cloudfront ? aws_cloudfront_origin_access_identity.oai[0].cloudfront_access_identity_path : ""
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}

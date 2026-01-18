output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = var.create_ecr ? aws_ecr_repository.backend[0].repository_url : ""
}

output "ecr_repository_arn" {
  description = "ECR repository ARN"
  value       = var.create_ecr ? aws_ecr_repository.backend[0].arn : ""
}

output "s3_bucket_id" {
  description = "S3 bucket ID"
  value       = var.create_s3 ? aws_s3_bucket.frontend[0].id : ""
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = var.create_s3 ? aws_s3_bucket.frontend[0].arn : ""
}

output "s3_bucket_domain" {
  description = "S3 bucket domain name"
  value       = var.create_s3 ? aws_s3_bucket.frontend[0].bucket_domain_name : ""
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = var.create_s3 ? aws_s3_bucket.frontend[0].bucket : ""
}

output "s3_website_endpoint" {
  description = "S3 website endpoint"
  value       = var.create_s3 ? aws_s3_bucket.frontend[0].website_endpoint : ""
}

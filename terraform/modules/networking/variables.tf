variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "create_cloudfront" {
  description = "Whether to create CloudFront distribution"
  type        = bool
  default     = false
}

variable "s3_bucket_id" {
  description = "S3 bucket ID for CloudFront"
  type        = string
  default     = ""
}

variable "s3_bucket_domain" {
  description = "S3 bucket domain for CloudFront"
  type        = string
  default     = ""
}

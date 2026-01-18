variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "create_ecr" {
  description = "Whether to create ECR repository"
  type        = bool
  default     = true
}

variable "create_s3" {
  description = "Whether to create S3 bucket"
  type        = bool
  default     = true
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = ""
}

variable "cloudfront_oai" {
  description = "CloudFront Origin Access Identity ARN"
  type        = string
  default     = ""
}

# ECR Repository for Docker images
resource "aws_ecr_repository" "backend" {
  count = var.create_ecr ? 1 : 0
  
  name = "${var.project_name}-${var.environment}-backend"
  
  image_scanning_configuration {
    scan_on_push = true
  }
  
  encryption_configuration {
    encryption_type = "AES256"
  }
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-ecr"
    Project     = var.project_name
    Environment = var.environment
  }
}

# S3 Bucket for Frontend
resource "aws_s3_bucket" "frontend" {
  count = var.create_s3 ? 1 : 0
  
  bucket = var.bucket_name
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-frontend"
    Project     = var.project_name
    Environment = var.environment
  }
}

# S3 Bucket ACL
resource "aws_s3_bucket_acl" "frontend" {
  count = var.create_s3 ? 1 : 0
  
  bucket = aws_s3_bucket.frontend[0].id
  acl    = "private"
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "frontend" {
  count = var.create_s3 ? 1 : 0
  
  bucket = aws_s3_bucket.frontend[0].id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "frontend" {
  count = var.create_s3 ? 1 : 0
  
  bucket = aws_s3_bucket.frontend[0].id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "frontend" {
  count = var.create_s3 ? 1 : 0
  
  bucket = aws_s3_bucket.frontend[0].id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Policy for CloudFront
resource "aws_s3_bucket_policy" "frontend" {
  count = var.create_s3 && length(var.cloudfront_oai) > 0 ? 1 : 0
  
  bucket = aws_s3_bucket.frontend[0].id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontRead"
        Effect = "Allow"
        Principal = {
          AWS = var.cloudfront_oai
        }
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.frontend[0].arn}/*"
        ]
      }
    ]
  })
}

# S3 Bucket Website Configuration
resource "aws_s3_bucket_website_configuration" "frontend" {
  count = var.create_s3 ? 1 : 0
  
  bucket = aws_s3_bucket.frontend[0].id
  
  index_document {
    suffix = "index.html"
  }
  
  error_document {
    key = "index.html"
  }
}

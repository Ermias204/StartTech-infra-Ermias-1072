# StartTech Infrastructure as Code

This repository contains Terraform configurations for deploying the StartTech application infrastructure on AWS.

## Repository: StartTech-infra-Ermias-1072

## Infrastructure Components

The Terraform configuration provisions the following AWS resources:

1. **Networking:**
   - VPC with public and private subnets
   - Internet Gateway and route tables
   - Security groups for ALB, EC2, Redis
   - CloudFront distribution for frontend CDN

2. **Compute:**
   - Auto Scaling Group with EC2 instances
   - Application Load Balancer (ALB) with target group
   - Launch template with user data for Docker deployment
   - ElastiCache Redis cluster for caching

3. **Storage:**
   - S3 bucket for React frontend hosting
   - ECR repository for Docker images
   - S3 bucket policies for CloudFront access

4. **Monitoring:**
   - CloudWatch Log Groups for application logs
   - CloudWatch Dashboard for metrics visualization
   - CloudWatch Alarms for error rate, response time, CPU

5. **Security:**
   - IAM roles and policies for EC2 instances
   - Security groups with least privilege access
   - Encrypted storage (S3, ECR)

## Directory Structure

StartTech-infra-Ermias-1072/
├── .github/workflows/
│ └── infrastructure-deploy.yml # CI/CD for Terraform
├── terraform/
│ ├── main.tf # Main Terraform configuration
│ ├── variables.tf # Input variables
│ ├── outputs.tf # Output values
│ ├── terraform.tfvars.example # Example variables file
│ └── modules/ # Reusable modules
│ ├── networking/ # VPC, subnets, CloudFront
│ ├── compute/ # EC2, ALB, Auto Scaling, Redis
│ ├── storage/ # S3, ECR
│ └── monitoring/ # CloudWatch logs, dashboards, alarms
├── scripts/
│ └── deploy-infrastructure.sh # Manual deployment script
├── monitoring/ # Monitoring configurations
│ ├── cloudwatch-dashboard.json # Dashboard definition
│ ├── alarm-definitions.json # Alarm configurations
│ └── log-insights-queries.txt # Log analysis queries
└── README.md # This file

text

## Prerequisites

1. **AWS Account** with appropriate permissions
2. **Terraform** v1.5.0 or higher installed locally
3. **AWS CLI** configured with credentials
4. **GitHub Secrets** configured for CI/CD

## GitHub Secrets Required

Configure these secrets in GitHub Repository Settings:

```bash
AWS_ACCESS_KEY_ID           # AWS IAM user access key
AWS_SECRET_ACCESS_KEY       # AWS IAM user secret key
AWS_REGION                  # eu-west-1
Deployment
Manual Deployment
bash
# Clone the repository
git clone <repository-url>
cd StartTech-infra-Ermias-1072

# Create terraform.tfvars from example
cp terraform/terraform.tfvars.example terraform/terraform.tfvars

# Edit terraform.tfvars with your values
nano terraform/terraform.tfvars

# Deploy infrastructure
./scripts/deploy-infrastructure.sh
CI/CD Deployment
The infrastructure deploys automatically via GitHub Actions when:

Changes are pushed to the main branch

Changes affect files in the terraform/ directory

Configuration
Edit terraform/terraform.tfvars with your specific values:

hcl
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

# S3 Bucket Name
s3_bucket_name = "starttech-frontend-Ermias-1072-app"
Outputs
After deployment, Terraform will output:

alb_dns_name - Application Load Balancer DNS name

cloudfront_distribution_id - CloudFront distribution ID

redis_endpoint - ElastiCache Redis endpoint

ecr_repository_url - ECR repository URL for Docker images

s3_bucket_name - S3 bucket name for frontend

These outputs should be added as GitHub Secrets in the application repository.

Cost Estimation
Monthly estimated costs (eu-west-1):

EC2 instances (t3.micro x 2): ~$15/month

ALB: ~$20/month

S3 (minimal usage): ~$1/month

CloudFront (minimal usage): ~$1/month

ElastiCache Redis (cache.t3.micro): ~$15/month

Total Estimated: ~$52/month

Security Notes
IAM Roles: EC2 instances use IAM roles with least privilege

Security Groups: Restrict traffic between components

Encryption: All storage encrypted at rest

Secrets: No secrets stored in Terraform files

Network: Private subnets for backend and Redis

Maintenance
Updates
Update Terraform version in main.tf

Update AWS provider version in main.tf

Update AMI IDs in compute module as needed

Monitoring
Check CloudWatch alarms regularly

Review CloudTrail logs for security

Monitor cost usage in AWS Cost Explorer

Troubleshooting
See the application repository's RUNBOOK.md for detailed troubleshooting procedures.

Related Repositories
Application Repository: StartTech-[Name]-1072 - React frontend and Golang backend with CI/CD

Infrastructure Repository: StartTech-infra-[Name]-1072 - This repository

Support
For issues with the infrastructure:

Check Terraform logs in GitHub Actions

Review AWS CloudTrail for API errors

Verify IAM permissions are correct

Ensure VPC quotas are not exceeded
```

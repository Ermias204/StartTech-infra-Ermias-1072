# Infrastructure Architecture

## Overview

This document describes the AWS infrastructure architecture for the StartTech application, deployed using Terraform.

## AWS Services Used

### Core Services
- **Amazon VPC:** Virtual Private Cloud for network isolation
- **Amazon EC2:** Compute instances for backend API
- **Auto Scaling:** Automatic scaling of EC2 instances
- **Application Load Balancer:** Traffic distribution and SSL termination
- **Amazon S3:** Static website hosting for React frontend
- **Amazon CloudFront:** Global CDN for frontend delivery
- **Amazon ElastiCache:** Redis for caching and sessions
- **Amazon ECR:** Container registry for Docker images

### Supporting Services
- **Amazon CloudWatch:** Monitoring, logging, and alerts
- **AWS IAM:** Identity and access management
- **AWS Certificate Manager:** SSL certificates (optional)
- **AWS Route 53:** DNS management (optional)

## Network Architecture

### VPC Design
VPC: 10.0.0.0/16
├── Public Subnets (10.0.1.0/24, 10.0.2.0/24)
│ ├── Application Load Balancer
│ └── NAT Gateway (if added)
└── Private Subnets (10.0.3.0/24, 10.0.4.0/24)
├── EC2 Instances (Auto Scaling Group)
└── ElastiCache Redis

text

### Availability Zones
- eu-west-1a, eu-west-1b, eu-west-1c
- Multi-AZ deployment for high availability
- Resources distributed across AZs for fault tolerance

### Security Groups

**ALB Security Group:**
- Ingress: HTTP/80, HTTPS/443 from 0.0.0.0/0
- Egress: All traffic to EC2 instances

**EC2 Security Group:**
- Ingress: HTTP/8080 from ALB security group
- Ingress: SSH/22 from restricted IPs (configurable)
- Egress: All traffic to internet and other services

**Redis Security Group:**
- Ingress: TCP/6379 from EC2 security group
- Egress: All traffic

## Compute Architecture

### Auto Scaling Group
- **Instance Type:** t3.micro (free tier eligible)
- **Min Size:** 2 instances
- **Max Size:** 5 instances
- **Desired Capacity:** 2 instances
- **Scaling Policies:** Based on CPU utilization

### Launch Configuration
- **AMI:** Amazon Linux 2
- **User Data:** Bash script for Docker setup
- **IAM Role:** Permissions for ECR, CloudWatch, S3
- **Storage:** 8GB GP2 root volume

## Storage Architecture

### S3 Bucket for Frontend
- Static website hosting enabled
- Versioning enabled for rollbacks
- Server-side encryption (SSE-S3)
- Lifecycle policies (configurable)
- CloudFront OAI for secure access

### ECR Repository
- Private Docker registry
- Image scanning on push
- Immutable tags support
- Lifecycle policies for old images

## Monitoring Architecture

### CloudWatch Logs
- **Application Logs:** /starttech/production/backend
- **ALB Access Logs:** /starttech/production/alb/access
- **Retention:** 30 days (configurable)

### CloudWatch Metrics
- **EC2:** CPUUtilization, NetworkIn/Out, DiskRead/Write
- **ALB:** RequestCount, TargetResponseTime, HTTP codes
- **Auto Scaling:** Group metrics

### CloudWatch Alarms
- High error rate (>10 5XX errors in 10 minutes)
- High response time (>2 seconds average)
- High CPU utilization (>80% for 5 minutes)
- Low request count (<10 requests in 10 minutes)

## Deployment Architecture

### Terraform State Management
- State stored in S3 (to be configured)
- State locking with DynamoDB (optional)
- Versioning enabled for state files

### CI/CD Integration
- GitHub Actions for automated deployment
- Terraform plan on pull requests
- Terraform apply on main branch push
- Output extraction for application secrets

## Security Architecture

### IAM Roles
- **EC2 Instance Role:** Limited to ECR pull, CloudWatch push
- **GitHub Actions Role:** Limited to specific resources
- **No long-term credentials on instances**

### Network Security
- Private subnets for sensitive components
- Security groups with least privilege
- No public IPs for backend instances
- VPC flow logs enabled (optional)

### Data Protection
- Encryption at rest (S3, EBS, ECR)
- Encryption in transit (TLS for all external traffic)
- No sensitive data in Terraform files

## Cost Optimization

### Right-Sizing
- t3.micro instances for development
- Auto-scaling based on actual load
- S3 storage classes based on access patterns

### Reserved Instances
- Consider RIs for predictable workloads
- Savings Plans for flexible usage
- Spot instances for fault-tolerant workloads

### Monitoring Costs
- CloudWatch custom metrics limited
- Log retention periods optimized
- Alarm thresholds set appropriately

## High Availability Design

### Multi-AZ Deployment
- Subnets across multiple availability zones
- Auto Scaling Group spans all AZs
- ALB routes to healthy instances in any AZ

### Load Distribution
- ALB health checks every 30 seconds
- Automatic instance replacement
- Connection draining enabled

### Disaster Recovery
- Terraform state backed up in S3
- MongoDB Atlas backups (external)
- Redis snapshots (configurable)
- S3 versioning for frontend files

## Scalability Design

### Horizontal Scaling
- Auto Scaling Group adds instances under load
- ALB distributes traffic evenly
- Stateless backend design

### Vertical Scaling
- Instance type can be upgraded
- Redis node type can be increased
- S3 automatically scales

### Database Scaling
- MongoDB Atlas auto-scaling (external)
- Redis read replicas (if needed)
- Connection pooling in application

## Maintenance Procedures

### Routine Maintenance
- AMI updates via new launch template
- Security group rule reviews
- IAM policy audits
- Cost optimization reviews

### Emergency Procedures
- Rollback via Terraform state
- Instance replacement via Auto Scaling
- Database restore from backups
- Frontend rollback via S3 versioning

## Future Enhancements

### Planned Improvements
- AWS WAF for web application firewall
- AWS Shield for DDoS protection
- AWS Secrets Manager for credential rotation
- AWS Backup for automated backups
- AWS X-Ray for distributed tracing

### Optional Components
- AWS Route 53 for custom domain
- AWS ACM for SSL certificates
- AWS WAF for security rules
- AWS GuardDuty for threat detection

# Infrastructure Operations Runbook

## Quick Reference

### AWS Console Links
- **VPC:** https://eu-west-1.console.aws.amazon.com/vpc
- **EC2:** https://eu-west-1.console.aws.amazon.com/ec2
- **S3:** https://s3.console.aws.amazon.com/s3
- **CloudFront:** https://console.aws.amazon.com/cloudfront
- **CloudWatch:** https://eu-west-1.console.aws.amazon.com/cloudwatch
- **ElastiCache:** https://eu-west-1.console.aws.amazon.com/elasticache
- **ECR:** https://eu-west-1.console.aws.amazon.com/ecr

### Terraform Commands
```bash
# Initialize
cd terraform && terraform init

# Plan changes
terraform plan -var-file="terraform.tfvars"

# Apply changes
terraform apply -var-file="terraform.tfvars"

# Destroy (CAUTION)
terraform destroy -var-file="terraform.tfvars"

# Show outputs
terraform output
Common Issues
Issue: Terraform State Errors
Symptoms: "Error acquiring state lock" or "State file not found"

Resolution:

bash
# Force unlock (if locked)
terraform force-unlock <LOCK_ID>

# Reinitialize with existing state
terraform init -reconfigure

# Import existing resources
terraform import <resource_type>.<name> <aws_id>
Issue: AWS Rate Limiting
Symptoms: "Rate exceeded" or "ThrottlingException"

Resolution:

Wait and retry with exponential backoff

Request service quota increase if needed

Implement retry logic in scripts

Issue: Insufficient IAM Permissions
Symptoms: "Access Denied" or "UnauthorizedOperation"

Resolution:

Check IAM user/role permissions

Verify policy attachments

Add missing permissions:

json
{
    "Effect": "Allow",
    "Action": [
        "ec2:DescribeInstances",
        "autoscaling:DescribeAutoScalingGroups",
        "elasticloadbalancing:DescribeLoadBalancers"
    ],
    "Resource": "*"
}
Issue: VPC Limits Exceeded
Symptoms: "VpcLimitExceeded" or "SubnetLimitExceeded"

Resolution:

Check current limits: aws ec2 describe-account-attributes

Request limit increase via AWS Support

Clean up unused resources

Maintenance Procedures
Monthly Maintenance
1. Security Updates:

bash
# Check for new AMI IDs
aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" --query "Images[0].ImageId"

# Update launch template if new AMI available
2. Cost Review:

bash
# Check current month costs
aws ce get-cost-and-usage \
    --time-period Start=2024-01-01,End=2024-01-31 \
    --granularity MONTHLY \
    --metrics "BlendedCost"
3. IAM Audit:

bash
# List IAM policies
aws iam list-policies --scope Local

# Check policy usage
aws iam list-entities-for-policy --policy-arn <policy_arn>
Quarterly Maintenance
1. Terraform Updates:

bash
# Update Terraform version in main.tf
# Update provider versions
# Test with terraform plan
2. Security Group Review:

bash
# List all security groups
aws ec2 describe-security-groups --filters "Name=tag:Project,Values=starttech"

# Review ingress/egress rules
3. Backup Verification:

Verify S3 versioning enabled

Check ECR lifecycle policies

Test Terraform state restoration

Emergency Procedures
Complete Infrastructure Failure
Step 1: Assess Damage

bash
# Check Terraform state
terraform state list

# Check AWS resources
./scripts/deploy-infrastructure.sh (first steps only)
Step 2: Recovery Options

Terraform Reapply: terraform apply -auto-approve

Manual Recreation: Use AWS Console for critical components

State Recovery: Restore from S3 versioning if state corrupted

Step 3: Communication

Update stakeholders on ETA

Document root cause

Implement preventive measures

Security Incident
Step 1: Containment

bash
# Revoke IAM credentials
aws iam update-access-key --access-key-id <KEY_ID> --status Inactive

# Update security groups (restrict access)
Step 2: Investigation

bash
# Check CloudTrail logs
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=ConsoleLogin

# Check VPC flow logs
Step 3: Remediation

Rotate all credentials

Apply security patches

Update IAM policies

Performance Troubleshooting
High Response Times
Check:

bash
# ALB response times
aws cloudwatch get-metric-statistics \
    --namespace AWS/ApplicationELB \
    --metric-name TargetResponseTime \
    --start-time $(date -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ) \
    --end-time $(date +%Y-%m-%dT%H:%M:%SZ) \
    --period 300 \
    --statistics Average

# EC2 CPU utilization
aws cloudwatch get-metric-statistics \
    --namespace AWS/EC2 \
    --metric-name CPUUtilization \
    --dimensions Name=AutoScalingGroupName,Value=starttech-production-asg \
    --start-time $(date -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ) \
    --end-time $(date +%Y-%m-%dT%H:%M:%SZ) \
    --period 300 \
    --statistics Average
Connection Errors
Check:

bash
# ALB 5XX errors
aws cloudwatch get-metric-statistics \
    --namespace AWS/ApplicationELB \
    --metric-name HTTPCode_Target_5XX_Count \
    --start-time $(date -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ) \
    --end-time $(date +%Y-%m-%dT%H:%M:%SZ) \
    --period 300 \
    --statistics Sum

# Target group health
aws elbv2 describe-target-health --target-group-arn <TG_ARN>
Cost Optimization
Daily Checks
bash
# Check for idle resources
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].{ID:InstanceId,Type:InstanceType,LaunchTime:LaunchTime}"

# Check for underutilized instances
aws cloudwatch get-metric-statistics \
    --namespace AWS/EC2 \
    --metric-name CPUUtilization \
    --start-time $(date -d '7 days ago' +%Y-%m-%dT%H:%M:%SZ) \
    --end-time $(date +%Y-%m-%dT%H:%M:%SZ) \
    --period 3600 \
    --statistics Average
Right-Sizing Recommendations
t3.micro → t3.small: If CPU > 40% consistently

Add Auto Scaling: For variable workloads

Reserved Instances: For predictable base load

Appendix
Useful AWS CLI Commands
List all resources:

bash
# EC2 instances
aws ec2 describe-instances --filters "Name=tag:Project,Values=starttech"

# S3 buckets
aws s3api list-buckets --query "Buckets[?contains(Name, 'starttech')]"

# CloudFront distributions
aws cloudfront list-distributions --query "DistributionList.Items[?Comment.contains(@, 'starttech')]"
Get resource details:

bash
# Get specific instance details
aws ec2 describe-instances --instance-ids <instance_id>

# Get ALB details
aws elbv2 describe-load-balancers --names starttech-production-alb

# Get Auto Scaling Group
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names starttech-production-asg
Contact Information
AWS Support: https://aws.amazon.com/contact-us

Terraform Documentation: https://www.terraform.io/docs

GitHub Actions Docs: https://docs.github.com/en/actions


Change Log
Date	Version	Changes
2024-01-17	1.0.0	Initial infrastructure deployment
Future	1.1.0	Add WAF, ACM certificates
Future	1.2.0	Multi-region deployment

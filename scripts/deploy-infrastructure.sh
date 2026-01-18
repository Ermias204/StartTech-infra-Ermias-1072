#!/bin/bash
set -e

echo "=== StartTech Infrastructure Deployment ==="
echo ""

# Check if AWS credentials are set
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "ERROR: AWS credentials not set!"
  echo "Please set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables."
  exit 1
fi

# Check if terraform.tfvars exists
if [ ! -f "terraform/terraform.tfvars" ]; then
  echo "ERROR: terraform/terraform.tfvars not found!"
  echo "Create it from the example: cp terraform/terraform.tfvars.example terraform/terraform.tfvars"
  echo "Then edit terraform/terraform.tfvars with your values."
  exit 1
fi

# Navigate to terraform directory
cd terraform

# Initialize Terraform
echo "Step 1: Initializing Terraform..."
terraform init

# Validate configuration
echo "Step 2: Validating Terraform configuration..."
terraform validate

# Plan changes
echo "Step 3: Planning changes..."
terraform plan -var-file="terraform.tfvars"

# Ask for confirmation
read -p "Do you want to apply these changes? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "Deployment cancelled."
  exit 0
fi

# Apply changes
echo "Step 4: Applying changes..."
terraform apply -auto-approve -var-file="terraform.tfvars"

# Show outputs
echo ""
echo "=== Deployment Complete ==="
echo ""
echo "Outputs:"
terraform output

echo ""
echo "=== Next Steps ==="
echo "1. Update GitHub Secrets in your Application Repository with these outputs:"
echo "   - CLOUDFRONT_DIST_ID"
echo "   - ALB_DNS_NAME"
echo "   - REDIS_ENDPOINT"
echo "2. Create MongoDB Atlas cluster and update MONGO_CONNECTION_STRING secret"
echo "3. Run the application deployment pipelines"
echo "4. Test the health check: ./scripts/health-check.sh"

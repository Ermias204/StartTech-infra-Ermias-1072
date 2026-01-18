#!/bin/bash
set -e

# Update system
yum update -y

# Install Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Install AWS CLI
yum install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Login to ECR
aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${ecr_repository_url}

# Create application directory
mkdir -p /app
cd /app

# Create docker-compose file
cat > docker-compose.yml << 'DOCKERFILE'
version: '3.8'

services:
  backend:
    image: ${ecr_repository_url}:latest
    restart: always
    ports:
      - "8080:8080"
    environment:
      - REDIS_HOST=${redis_endpoint}
      - REDIS_PORT=6379
      - MONGODB_URI=${mongo_connection}
      - PORT=8080
    logging:
      driver: awslogs
      options:
        awslogs-region: ${region}
        awslogs-group: ${project_name}-${environment}-backend
        awslogs-stream-prefix: backend
DOCKERFILE

# Create systemd service
cat > /etc/systemd/system/backend.service << 'SERVICE'
[Unit]
Description=Backend Service
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/app
ExecStart=/usr/local/bin/docker-compose up -d
ExecStop=/usr/local/bin/docker-compose down

[Install]
WantedBy=multi-user.target
SERVICE

# Enable and start service
systemctl daemon-reload
systemctl enable backend.service
systemctl start backend.service

# Create health check script
cat > /usr/local/bin/health_check.sh << 'HEALTH'
#!/bin/bash
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/health)
if [ "$RESPONSE" = "200" ]; then
  exit 0
else
  exit 1
fi
HEALTH

chmod +x /usr/local/bin/health_check.sh

# Schedule health check cron job
echo "*/5 * * * * /usr/local/bin/health_check.sh" | crontab -

# Install CloudWatch agent for advanced metrics
yum install -y amazon-cloudwatch-agent

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:AmazonCloudWatch-linux

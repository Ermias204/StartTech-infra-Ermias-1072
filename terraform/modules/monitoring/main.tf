# CloudWatch Log Group for Backend
resource "aws_cloudwatch_log_group" "backend" {
  name              = "/${var.project_name}/${var.environment}/backend"
  retention_in_days = 30

  tags = {
    Name        = "${var.project_name}-${var.environment}-backend-logs"
    Project     = var.project_name
    Environment = var.environment
  }
}

# CloudWatch Log Group for ALB Access Logs
resource "aws_cloudwatch_log_group" "alb_access" {
  name              = "/${var.project_name}/${var.environment}/alb/access"
  retention_in_days = 30

  tags = {
    Name        = "${var.project_name}-${var.environment}-alb-access-logs"
    Project     = var.project_name
    Environment = var.environment
  }
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", { "LoadBalancer": var.alb_arn }]
          ]
          period = 300
          stat   = "Sum"
          region = "eu-west-1"
          title  = "ALB Request Count"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", { "LoadBalancer": var.alb_arn }]
          ]
          period = 300
          stat   = "Sum"
          region = "eu-west-1"
          title  = "ALB 2XX Responses"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", { "LoadBalancer": var.alb_arn }]
          ]
          period = 300
          stat   = "Sum"
          region = "eu-west-1"
          title  = "ALB 5XX Errors"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", { "AutoScalingGroupName": var.auto_scaling_group_name }]
          ]
          period = 300
          stat   = "Average"
          region = "eu-west-1"
          title  = "EC2 CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", { "LoadBalancer": var.alb_arn }]
          ]
          period = 300
          stat   = "Average"
          region = "eu-west-1"
          title  = "ALB Response Time"
        }
      },
      {
        type   = "log"
        x      = 12
        y      = 12
        width  = 12
        height = 6

        properties = {
          query   = "SOURCE '${aws_cloudwatch_log_group.backend.name}' | fields @timestamp, @message | sort @timestamp desc | limit 20"
          region  = "eu-west-1"
          title   = "Backend Logs"
          view    = "table"
        }
      }
    ]
  })
}

# CloudWatch Alarm for High Error Rate
resource "aws_cloudwatch_metric_alarm" "high_error_rate" {
  alarm_name          = "${var.project_name}-${var.environment}-high-error-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "HTTPCode_Target_5XX_Count"
  namespace         = "AWS/ApplicationELB"
  period            = "300"
  statistic         = "Sum"
  threshold         = "10"
  alarm_description = "This metric monitors ALB 5XX errors"
  alarm_actions     = [] # Add SNS topic ARN for notifications

  dimensions = {
    LoadBalancer = var.alb_arn
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-error-alarm"
    Project     = var.project_name
    Environment = var.environment
  }
}

# CloudWatch Alarm for High Response Time
resource "aws_cloudwatch_metric_alarm" "high_response_time" {
  alarm_name          = "${var.project_name}-${var.environment}-high-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "TargetResponseTime"
  namespace         = "AWS/ApplicationELB"
  period            = "300"
  statistic         = "Average"
  threshold         = "2"
  alarm_description = "This metric monitors ALB response time"
  alarm_actions     = [] # Add SNS topic ARN for notifications

  dimensions = {
    LoadBalancer = var.alb_arn
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-response-time-alarm"
    Project     = var.project_name
    Environment = var.environment
  }
}

# CloudWatch Alarm for Low Request Count
resource "aws_cloudwatch_metric_alarm" "low_request_count" {
  alarm_name          = "${var.project_name}-${var.environment}-low-request-count"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "RequestCount"
  namespace         = "AWS/ApplicationELB"
  period            = "300"
  statistic         = "Sum"
  threshold         = "10"
  alarm_description = "This metric monitors ALB request count"
  alarm_actions     = [] # Add SNS topic ARN for notifications

  dimensions = {
    LoadBalancer = var.alb_arn
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-request-count-alarm"
    Project     = var.project_name
    Environment = var.environment
  }
}

# CloudWatch Alarm for High CPU
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "CPUUtilization"
  namespace         = "AWS/EC2"
  period            = "120"
  statistic         = "Average"
  threshold         = "80"
  alarm_description = "This metric monitors EC2 CPU utilization"
  alarm_actions     = [] # Add SNS topic ARN for notifications

  dimensions = {
    AutoScalingGroupName = var.auto_scaling_group_name
  }
}

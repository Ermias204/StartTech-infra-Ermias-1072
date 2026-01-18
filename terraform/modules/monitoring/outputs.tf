output "cloudwatch_log_group_name" {
  description = "CloudWatch log group name for backend"
  value       = aws_cloudwatch_log_group.backend.name
}

output "cloudwatch_log_group_arn" {
  description = "CloudWatch log group ARN for backend"
  value       = aws_cloudwatch_log_group.backend.arn
}

output "cloudwatch_dashboard_name" {
  description = "CloudWatch dashboard name"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "cloudwatch_alarm_high_error_rate_arn" {
  description = "High error rate alarm ARN"
  value       = aws_cloudwatch_metric_alarm.high_error_rate.arn
}

output "cloudwatch_alarm_high_response_time_arn" {
  description = "High response time alarm ARN"
  value       = aws_cloudwatch_metric_alarm.high_response_time.arn
}

output "cloudwatch_alarm_low_request_count_arn" {
  description = "Low request count alarm ARN"
  value       = aws_cloudwatch_metric_alarm.low_request_count.arn
}

output "cloudwatch_alarm_high_cpu_arn" {
  description = "High CPU alarm ARN"
  value       = aws_cloudwatch_metric_alarm.high_cpu.arn
}

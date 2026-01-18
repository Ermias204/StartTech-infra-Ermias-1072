output "ec2_security_group_id" {
  description = "EC2 security group ID"
  value       = aws_security_group.ec2.id
}

output "redis_security_group_id" {
  description = "Redis security group ID"
  value       = var.create_redis ? aws_security_group.redis[0].id : ""
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.backend.dns_name
}

output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.backend.arn
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = aws_lb_target_group.backend.arn
}

output "auto_scaling_group_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.backend.name
}

output "redis_endpoint" {
  description = "Redis endpoint"
  value       = var.create_redis ? aws_elasticache_cluster.redis[0].cache_nodes[0].address : ""
}

output "redis_port" {
  description = "Redis port"
  value       = var.create_redis ? aws_elasticache_cluster.redis[0].port : ""
}

output "launch_template_id" {
  description = "Launch template ID"
  value       = aws_launch_template.backend.id
}

output "ec2_instance_profile_name" {
  description = "EC2 instance profile name"
  value       = aws_iam_instance_profile.ec2.name
}

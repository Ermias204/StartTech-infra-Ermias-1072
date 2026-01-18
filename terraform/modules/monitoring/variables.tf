variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "alb_arn" {
  description = "ALB ARN"
  type        = string
}

variable "auto_scaling_group_name" {
  description = "Auto Scaling Group name"
  type        = string
}

variable "ec2_instance_id" {
  description = "EC2 instance ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

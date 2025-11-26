############################################################
# SecureTheCloud — AWS Monitoring Module Outputs
############################################################

output "cloudtrail_bucket" {
  description = "S3 bucket used for CloudTrail logs"
  value       = var.cloudtrail_bucket
}

output "flow_logs_bucket" {
  description = "S3 bucket used for VPC Flow Logs"
  value       = var.flow_logs_bucket
}

output "alb_logs_bucket" {
  description = "S3 bucket used for ALB access logs"
  value       = var.alb_logs_bucket
}

output "alb_arn" {
  description = "Application Load Balancer ARN used for access logs"
  value       = var.alb_arn
}

output "vpc_id" {
  description = "VPC ID where monitoring is enabled"
  value       = var.vpc_id
}

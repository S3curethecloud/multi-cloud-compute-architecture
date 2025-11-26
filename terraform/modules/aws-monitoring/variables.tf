variable "prefix" {
  type        = string
  description = "Prefix for monitoring/logging resources"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "alb_arn" {
  type        = string
  description = "ARN of the existing ALB"
}

variable "flow_logs_bucket" {
  type        = string
  description = "S3 bucket for VPC Flow Logs"
}

variable "alb_logs_bucket" {
  type        = string
  description = "S3 bucket for ALB access logs"
}

variable "cloudtrail_bucket" {
  type        = string
  description = "S3 bucket for CloudTrail logs"
}

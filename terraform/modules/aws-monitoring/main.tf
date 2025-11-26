
resource "aws_s3_bucket" "flowlogs" {
  bucket        = var.flow_logs_bucket
  force_destroy = true
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = var.cloudtrail_bucket
  force_destroy = true
}

###############################################
# AWS Monitoring & Logging Module
###############################################

# VPC Flow Logs → S3
resource "aws_flow_log" "vpc_flow" {
  log_destination      = "arn:aws:s3:::${var.flow_logs_bucket}"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id
}

###############################################
# CLOUDTRAIL → S3 (Management Events Only)
###############################################

data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "ct" {
  name                          = "${var.prefix}-cloudtrail"
  s3_bucket_name                = var.cloudtrail_bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = var.cloudtrail_bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action   = "s3:GetBucketAcl"
        Resource = "arn:aws:s3:::${var.cloudtrail_bucket}"
      },
      {
        Sid = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::${var.cloudtrail_bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}


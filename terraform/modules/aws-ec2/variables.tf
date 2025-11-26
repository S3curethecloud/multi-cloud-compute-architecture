variable "name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "kms_key_id" {
  type = string
}

variable "instance_profile" {
  type = string
}

variable "target_group_arn" {
  description = "The ALB Target Group ARN to attach the EC2 instance to"
  type        = string
}

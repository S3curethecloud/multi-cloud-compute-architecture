###############################
# AWS Variables
###############################

variable "aws_region" {}

###############################
# Azure Variables
###############################

variable "azure_location" {
  description = "Azure region for deployment"
  type        = string
  default     = "East US"
}

variable "azure_resource_group" {
  description = "Resource Group name for Azure workloads"
  type        = string
  default     = "stc-rg"
}

variable "azure_vnet_cidr" {
  description = "Azure VNet CIDR"
  type        = string
  default     = "10.20.0.0/16"
}

variable "azure_subnet_frontend_cidr" {
  description = "CIDR for Azure frontend (LB) subnet"
  type        = string
  default     = "10.20.1.0/24"
}

variable "azure_subnet_backend_cidr" {
  description = "CIDR for Azure VM subnet"
  type        = string
  default     = "10.20.2.0/24"
}

variable "azure_vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B1s"
}

variable "azure_admin_username" {
  description = "Admin username for Azure VM"
  type        = string
  default     = "cloudlab"
}

variable "azure_admin_password" {
  description = "Admin password for Azure VM"
  type        = string
  sensitive   = true
}

variable "azure_client_id" {
  description = "Azure Service Principal: appId"
  type        = string
}

variable "azure_client_secret" {
  description = "Azure Service Principal: password"
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Azure tenant from Service Principal"
  type        = string
}

variable "azure_subscription_id" {
  description = "Azure subscription ID for deployment"
  type        = string
}


###########################
# Azure Variables
###########################

variable "azure_location" {
  type    = string
  default = "East US"
}

variable "azure_resource_group" {
  type    = string
  default = "stc-rg"
}

variable "azure_vnet_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "azure_subnet_frontend_cidr" {
  type    = string
  default = "10.20.1.0/24"
}

variable "azure_subnet_backend_cidr" {
  type    = string
  default = "10.20.2.0/24"
}

variable "azure_vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "azure_admin_username" {
  type    = string
  default = "cloudlab"
}

variable "azure_admin_password" {
  type      = string
  sensitive = true
}

# Service Principal credentials
variable "azure_client_id" {
  type = string
}

variable "azure_client_secret" {
  type      = string
  sensitive = true
}

variable "azure_tenant_id" {
  type = string
}

variable "azure_subscription_id" {
  type = string
}

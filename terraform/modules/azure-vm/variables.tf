###############################################
# Azure VM Module Variables
###############################################

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "backend_pool_id" {
  type = string
}

variable "nsg_id" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "ssh_public_key_path" {
  type = string
}

variable "prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "nsg_id" {
  type = string
}

# NEW — required for VNet Flow Logs
variable "vnet_id" {
  type = string
}

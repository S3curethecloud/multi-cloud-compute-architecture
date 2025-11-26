variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type    = string
  default = "us-central1"
}

variable "gcp_zone" {
  type    = string
  default = "us-central1-a"
}

variable "vm_name" {
  type    = string
  default = "stc-gcp-vm"
}

variable "network_name" {
  type    = string
  default = "stc-gcp-network"
}


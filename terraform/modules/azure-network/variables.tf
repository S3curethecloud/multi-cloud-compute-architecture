variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnet_a_prefix" {
  type = list(string)
}

variable "subnet_b_prefix" {
  type = list(string)
}

output "external_ip" {
  value = module.gcp_vm.external_ip
}

output "internal_ip" {
  value = module.gcp_vm.internal_ip
}

output "network_name" {
  value = module.gcp_network.network_name
}

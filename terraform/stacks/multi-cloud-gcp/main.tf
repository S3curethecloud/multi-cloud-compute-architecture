module "gcp_network" {
  source       = "../../modules/gcp-network"
  network_name = var.network_name
  project_id   = var.gcp_project_id
  region       = var.gcp_region
}

module "gcp_vm" {
  source        = "../../modules/gcp-vm"
  vm_name       = var.vm_name
  project_id    = var.gcp_project_id
  subnet        = module.gcp_network.public_subnet_self_link
  zone          = var.gcp_zone
  region        = var.gcp_region
  network       = module.gcp_network.network_self_link
}

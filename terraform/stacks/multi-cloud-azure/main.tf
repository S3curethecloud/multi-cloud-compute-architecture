########################################
#   AZURE PROVIDER
#######################################
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

###############################################
# AZURE NETWORK MODULE
###############################################
module "azure_network" {
  source        = "../../modules/azure-network"

  name          = "stc-azure"
  location      = var.azure_location

  address_space   = [var.azure_vnet_cidr]
  subnet_a_prefix = [var.azure_subnet_frontend_cidr]
  subnet_b_prefix = [var.azure_subnet_backend_cidr]
}

###############################################
# AZURE LOAD BALANCER
###############################################
module "azure_lb" {
  source = "../../modules/azure-lb"

  name           = "stc-lb"
  location       = var.azure_location
  resource_group = module.azure_network.resource_group
  }

###############################################
# AZURE VIRTUAL MACHINE
###############################################
module "azure_vm" {
  source = "../../modules/azure-vm"

  name            = "stc-azure-vm"
  location        = var.azure_location
  resource_group  = module.azure_network.resource_group

  vm_size         = var.azure_vm_size
  admin_username  = var.azure_admin_username
  admin_password  = var.azure_admin_password
  ssh_public_key_path = "~/.ssh/id_rsa.pub"

  private_subnet_id = module.azure_network.private_a_id
  backend_pool_id   = module.azure_lb.backend_pool_id
  nsg_id            = module.azure_network.zero_trust_nsg_id
}

###############################################
# AZURE MONITORING & LOGGING
###############################################
module "azure_monitoring" {
  source = "../../modules/azure-monitoring"

  prefix         = "stc"
  resource_group = module.azure_network.resource_group
  location       = var.azure_location
  subscription_id = var.azure_subscription_id
  nsg_id         = module.azure_network.zero_trust_nsg_id
  vnet_id = module.azure_network.vnet_id
}

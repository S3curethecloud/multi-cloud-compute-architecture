###############################################
# SecureTheCloud — Azure Load Balancer Module
###############################################

resource "azurerm_public_ip" "lb_public_ip" {
  name                = "${var.name}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

###############################################
# LOAD BALANCER
###############################################

resource "azurerm_lb" "lb" {
  name                = "${var.name}-lb"
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontEnd"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

###############################################
# BACKEND POOL
###############################################

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = "${var.name}-backend-pool"
  loadbalancer_id = azurerm_lb.lb.id
}

###############################################
# HEALTH PROBE (HTTP)
###############################################

resource "azurerm_lb_probe" "http_probe" {
  name                = "${var.name}-http-probe"
  resource_group_name = var.resource_group
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
}

###############################################
# LOAD BALANCER RULE
###############################################

resource "azurerm_lb_rule" "http_rule" {
  name                           = "${var.name}-http-rule"
  resource_group_name            = var.resource_group
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.http_probe.id
}

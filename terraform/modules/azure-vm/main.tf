###########################################################
# SecureTheCloud – Azure VM Module
###########################################################

###############################
# NETWORK INTERFACE
###############################

resource "azurerm_network_interface" "nic" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.private_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

###############################
# ATTACH NSG TO NIC
###############################

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = var.nsg_id
}

###############################
# VIRTUAL MACHINE
###############################

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.name}-vm"
  location            = var.location
  resource_group_name = var.resource_group
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "${var.name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  computer_name                = "${var.name}-vm"
  disable_password_authentication = true

  custom_data = filebase64("${path.module}/cloud-init.yaml")

  tags = {
    environment = "production"
    name        = var.name
  }
}

###############################
# NIC → LOAD BALANCER BACKEND POOL
###############################

resource "azurerm_network_interface_backend_address_pool_association" "nic_lb_association" {
  network_interface_id    = azurerm_network_interface.nic.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = var.backend_pool_id
}

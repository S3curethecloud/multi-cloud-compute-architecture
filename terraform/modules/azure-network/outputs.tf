###############################################
# Azure Network Outputs
###############################################

output "resource_group" {
  value = azurerm_resource_group.rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "private_a_id" {
  value = azurerm_subnet.private_a.id
}

output "private_b_id" {
  value = azurerm_subnet.private_b.id
}

output "public_a_id" {
  value = azurerm_subnet.public_a.id
}

output "public_b_id" {
  value = azurerm_subnet.public_b.id
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

# ⭐ ADD THIS BLOCK HERE
output "zero_trust_nsg_id" {
  value = azurerm_network_security_group.zero_trust.id
}

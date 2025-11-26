###############################################
# SecureTheCloud – Azure Monitoring Module
# Modern version with VNet Flow Logs (Flow Logs v2)
###############################################

# Normalize region: "East US" -> "eastus"
locals {
  watcher_location = replace(lower(var.location), " ", "")
}

###############################################
# Storage Account for Log Retention
###############################################

resource "azurerm_storage_account" "logs" {
  name                     = "${var.prefix}logs${random_string.suffix.result}"
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  special = false
}

###############################################
# Log Analytics Workspace
###############################################

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

###############################################
# Activity Log Diagnostics (Subscription Logs)
###############################################

resource "azurerm_monitor_diagnostic_setting" "activity_logs" {
  name                       = "${var.prefix}-diag"
  target_resource_id         = "/subscriptions/${var.subscription_id}"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "Administrative"
  }

  enabled_log {
    category = "Security"
  }

  enabled_log {
    category = "ServiceHealth"
  }

  enabled_log {
    category = "Alert"
  }

  enabled_log {
    category = "Recommendation"
  }
}

###############################################
# VNet Flow Logs v2 (REPLACES NSG FLOW LOGS)
###############################################

# resource "azurerm_network_watcher_flow_log" "vnet_flowlogs" {
# name                = "${var.prefix}-vnet-flowlogs"
# resource_group_name = "NetworkWatcherRG"
# location            = var.location

# network_watcher_name = "NetworkWatcher_${local.watcher_location}"
# target_resource_id   = var.vnet_id        # <-- VNET, NOT NSG

# storage_account_id = azurerm_storage_account.logs.id
# enabled            = true

# retention_policy {
#   enabled = true
#   days    = 30
#  }
# }

###############################################
# NSG Diagnostics Logs (NO METRICS — SAFE)
###############################################

resource "azurerm_monitor_diagnostic_setting" "nsg_diagnostics" {
  name                       = "${var.prefix}-nsg-diagnostics"
  target_resource_id         = var.nsg_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}

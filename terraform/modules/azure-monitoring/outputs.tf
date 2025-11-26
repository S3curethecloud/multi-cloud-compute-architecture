output "log_analytics_id" {
  value = azurerm_log_analytics_workspace.law.id
}

output "storage_account_id" {
  value = azurerm_storage_account.logs.id
}


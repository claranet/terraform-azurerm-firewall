resource "azurerm_monitor_diagnostic_setting" "log_settings_storage" {
  count = "${var.enable_logs_to_storage ? 1 : 0}"

  name               = "logs-firewall-storage"
  target_resource_id = "${azurerm_firewall.firewall.id}"

  storage_account_id = "${var.logs_storage_account_id}"

  log {
    category = "AzureFirewallApplicationRule"

    retention_policy {
      enabled = true
      days    = "${var.logs_storage_retention}"
    }
  }

  log {
    category = "AzureFirewallNetworkRule"

    retention_policy {
      enabled = true
      days    = "${var.logs_storage_retention}"
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "log_settings_log_analytics" {
  count = "${var.enable_logs_to_log_analytics? 1 : 0}"

  name               = "logs-firewall-log-analytics"
  target_resource_id = "${azurerm_firewall.firewall.id}"

  log_analytics_workspace_id = "${var.logs_log_analytics_workspace_id}"

  log {
    category = "AzureFirewallApplicationRule"

    retention_policy {
      enabled = true
      days    = "${var.logs_storage_retention}"
    }
  }

  log {
    category = "AzureFirewallNetworkRule"

    retention_policy {
      enabled = true
      days    = "${var.logs_storage_retention}"
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "log_settings_eventhub" {
  count = "${var.enable_logs_to_eventhub? 1 : 0}"

  name               = "logs-firewall-eventhub"
  target_resource_id = "${azurerm_firewall.firewall.id}"

  eventhub_name                  = "${var.logs_eventhub_workspace_name}"
  eventhub_authorization_rule_id = "${var.logs_eventhub_authorization_rule_id}"

  log {
    category = "AzureFirewallApplicationRule"

    retention_policy {
      enabled = true
      days    = "${var.logs_storage_retention}"
    }
  }

  log {
    category = "AzureFirewallNetworkRule"

    retention_policy {
      enabled = true
      days    = "${var.logs_storage_retention}"
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
}

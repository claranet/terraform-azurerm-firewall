resource "azurerm_resource_group_template_deployment" "firewall_workbook_logs" {
  count = var.deploy_log_workbook && local.log_analytics_name != null ? 1 : 0

  name                = "AzureFirewallMonitorWorkbook"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  template_content    = file(format("%s/arm-templates/Azure Firewall_ARM.json", path.module))

  parameters_content = jsonencode({
    DiagnosticsWorkspaceName = {
      value = local.log_analytics_name
    },
    DiagnosticsWorkspaceSubscription = {
      value = local.log_analytics_subscription_id
    },
    DiagnosticsWorkspaceResourceGroup = {
      value = local.log_analytics_resource_group_name
    }
  })

  # Avoid perpetual changes due to default parameters
  lifecycle {
    ignore_changes = [parameters_content]
  }
}

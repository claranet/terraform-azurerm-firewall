variable "enabled" {
  description = "Set to true or false to create or not the firewall"
  type        = "string"
  default     = false
}

variable "location" {
  description = "Azure region to use"
  type        = "string"
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = "string"
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = "string"
}

variable "custom_firewall_name" {
  description = "Optional custom firewall name"
  type        = "string"
  default     = ""
}

variable "environment" {
  description = "Project environment"
  type        = "string"
}

variable "stack" {
  description = "Project stack name"
  type        = "string"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = "string"
}

variable "ip_configuration_name" {
  description = "Name of the ip_configuration block. https://www.terraform.io/docs/providers/azurerm/r/firewall.html#ip_configuration"
  type        = "string"
  default     = "ip_configuration"
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = "map"
  default     = {}
}

variable "virtual_network_name" {
  description = "Name of the vnet attached to the firewall."
  type        = "string"
}

variable "subnet_cidr" {
  description = "The address prefix to use for the firewall's subnet"
  type        = "string"
}

variable "add_network_rules" {
  description = "Add a Network Rule Collection within the Azure Firewall, or not. Set to true or false."
  type        = "string"
  default     = "false"
}

variable "network_rule_collection_name" {
  description = "Specifies the name of the Network Rule Collection which must be unique within the Firewall. Changing this forces a new resource to be created."
  type        = "string"
  default     = "network_rule_collection1"
}

variable "network_rule_collection_priority" {
  description = "Specifies the priority of the rule collection. Possible values are between 100 - 65000. https://www.terraform.io/docs/providers/azurerm/r/firewall_network_rule_collection.html#priority"
  type        = "string"
  default     = "100"
}

variable "network_rule_collection_action" {
  description = "Specifies the action the rules will apply to matching traffic. Possible values are Allow and Deny. https://www.terraform.io/docs/providers/azurerm/r/firewall_network_rule_collection.html#action"
  type        = "string"
  default     = "Deny"
}

variable "network_rules" {
  description = "A list of network rule blocks. Format: https://www.terraform.io/docs/providers/azurerm/r/firewall_network_rule_collection.html#rule"
  type        = "list"
  default     = []
}

variable "add_app_rules" {
  description = "Add an Application Rule Collection within the Azure Firewall, or not. Set to true or false."
  type        = "string"
  default     = "false"
}

variable "app_rule_collection_name" {
  description = "Specifies the name of the Application Rule Collection which must be unique within the Firewall. Changing this forces a new resource to be created."
  type        = "string"
  default     = "app_rule_collection1"
}

variable "app_rule_collection_priority" {
  description = "Specifies the priority of the application rule collection. Possible values are between 100 - 65000. https://www.terraform.io/docs/providers/azurerm/r/firewall_application_rule_collection.html#priority"
  type        = "string"
  default     = "100"
}

variable "app_rule_collection_action" {
  description = "Specifies the action the rules will apply to matching traffic. Possible values are Allow and Deny. https://www.terraform.io/docs/providers/azurerm/r/firewall_application_rule_collection.html#action"
  type        = "string"
  default     = "Deny"
}

variable "application_rules" {
  description = "A list of application rule blocks. Format: https://www.terraform.io/docs/providers/azurerm/r/firewall_application_rule_collection.html#rule . About the fqdn_tags in app rules: https://docs.microsoft.com/en-us/azure/firewall/fqdn-tags"
  type        = "list"
  default     = []
}

variable "add_nat_rules" {
  description = "Add an NAT Rule Collection within the Azure Firewall, or not. Set to true or false."
  type        = "string"
  default     = "false"
}

variable "nat_rule_collection_name" {
  description = "Specifies the name of the NAT Rule Collection which must be unique within the Firewall. Changing this forces a new resource to be created."
  type        = "string"
  default     = "nat_rule_collection1"
}

variable "nat_rule_collection_priority" {
  description = "Specifies the priority of the NAT rule collection. Possible values are between 100 - 65000. https://www.terraform.io/docs/providers/azurerm/r/firewall_nat_rule_collection.html#priority"
  type        = "string"
  default     = "100"
}

variable "nat_rule_collection_action" {
  description = "Specifies the action the rules will apply to matching traffic. Possible values are Dnat and Snat. https://www.terraform.io/docs/providers/azurerm/r/firewall_nat_rule_collection.html#action"
  type        = "string"
  default     = ""
}

variable "nat_rules" {
  description = "A list of NAT rule blocks. Format: https://www.terraform.io/docs/providers/azurerm/r/firewall_nat_rule_collection.html#rule"
  type        = "list"
  default     = []
}

variable "enable_logs_to_storage" {
  description = "Boolean flag to specify whether the logs should be sent to the Storage Account"
  type        = "string"
  default     = "false"
}

variable "enable_logs_to_log_analytics" {
  description = "Boolean flag to specify whether the logs should be sent to Log Analytics"
  type        = "string"
  default     = "false"
}

variable "enable_logs_to_eventhub" {
  description = "Boolean flag to specify whether the logs should be sent to EventHub"
  type        = "string"
  default     = "false"
}

variable "logs_storage_retention" {
  description = "Retention in days for logs on Storage Account"
  type        = "string"
  default     = "30"
}

variable "logs_storage_account_id" {
  description = "Storage Account id for logs"
  type        = "string"
  default     = ""
}

variable "logs_log_analytics_workspace_id" {
  description = "Log Analytics Workspace id for logs"
  type        = "string"
  default     = ""
}

variable "logs_eventhub_workspace_name" {
  description = "Specifies the name of the Event Hub where Diagnostics Data should be sent."
  type        = "string"
  default     = ""
}

variable "logs_eventhub_authorization_rule_id" {
  description = "Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data."
  type        = "string"
  default     = ""
}

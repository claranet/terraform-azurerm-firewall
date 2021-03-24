variable "location" {
  description = "Azure region to use"
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "custom_firewall_name" {
  description = "Optional custom firewall name"
  type        = string
  default     = ""
}

variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "ip_configuration_name" {
  description = "Name of the ip_configuration block. https://www.terraform.io/docs/providers/azurerm/r/firewall.html#ip_configuration"
  type        = string
  default     = "ip_configuration"
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

variable "virtual_network_name" {
  description = "Name of the vnet attached to the firewall."
  type        = string
}

variable "subnet_cidr" {
  description = "The address prefix to use for the firewall's subnet"
  type        = string
}

variable "network_rule_collections" {
  description = "Create a network rule collection"
  type = list(object({
    name     = string,
    priority = number,
    action   = string,
    rules = list(object({
      name                  = string,
      source_addresses      = list(string),
      source_ip_groups      = list(string),
      destination_ports     = list(string),
      destination_addresses = list(string),
      destination_ip_groups = list(string),
      destination_fqdns     = list(string),
      protocols             = list(string)
    }))
  }))
  default = null
}

variable "application_rule_collections" {
  description = "Create an application rule collection"
  type = list(object({
    name     = string,
    priority = number,
    action   = string,
    rules = list(object({
      name             = string,
      source_addresses = list(string),
      source_ip_groups = list(string),
      target_fqdns     = list(string),
      protocols = list(object({
        port = string,
        type = string
      }))
    }))
  }))
  default = null
}

variable "nat_rule_collections" {
  description = "Create a Nat rule collection"
  type = list(object({
    name     = string,
    priority = number,
    action   = string,
    rules = list(object({
      name                  = string,
      source_addresses      = list(string),
      source_ip_groups      = list(string),
      destination_ports     = list(string),
      destination_addresses = list(string),
      translated_port       = number,
      translated_address    = string,
      protocols             = list(string)
    }))
  }))
  default = null
}

variable "logs_destinations_ids" {
  description = "List of IDs (storage, logAnalytics Workspace, EventHub) to push logs to."
  type        = list(string)
  default     = null
}

variable "logs_categories" {
  description = "List of logs categories to log"
  type        = list(string)
  default     = null
}

variable "logs_metrics_categories" {
  description = "List of metrics categories to log"
  type        = list(string)
  default     = null
}

variable "logs_retention_days" {
  description = "Number of days to keep logs."
  type        = number
  default     = 32
}

variable "public_ip_custom_name" {
  description = "Custom name for the public IP"
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "DNS Servers to use with Azure Firewall. Using this also activate DNS Proxy."
  type        = list(string)
  default     = null
}

variable "additional_public_ips" {
  description = "List of additional public ips' ids to attach to the firewall."
  type = list(object({
    name                 = string,
    public_ip_address_id = string
  }))
  default = []
}

variable "deploy_log_workbook" {
  description = "Deploy Azure Workbook Log in log analytics workspace. [GitHub Azure](https://github.com/Azure/Azure-Network-Security/tree/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook)"
  type        = bool
  default     = true

}

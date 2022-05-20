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

variable "sku_tier" {
  description = "SKU tier of the Firewall. Possible values are `Premium` and `Standard`"
  type        = string
  default     = "Standard"
}

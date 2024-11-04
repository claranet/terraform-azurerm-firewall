variable "location" {
  description = "Azure region to use."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming."
  type        = string
}

variable "environment" {
  description = "Project environment."
  type        = string
}

variable "stack" {
  description = "Project stack name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the vnet attached to the firewall."
  type        = string
}

variable "subnet_cidr" {
  description = "The address prefix to use for the firewall's subnet."
  type        = string
}

variable "public_ip_zones" {
  description = "Public IP zones to configure."
  type        = list(number)
  default     = [1, 2, 3]
}

variable "private_ip_ranges" {
  description = "A list of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918."
  type        = list(string)
  default     = null
}

variable "network_rule_collections" {
  description = "Create a network rule collection."
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
  description = "Create an application rule collection."
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
  description = "Create a Nat rule collection."
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
  description = "Deploy Azure Workbook Log in log analytics workspace. [GitHub Azure](https://github.com/Azure/Azure-Network-Security/tree/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook)."
  type        = bool
  default     = true
}

variable "sku_tier" {
  description = "SKU tier of the Firewall. Possible values are `Premium` and `Standard`."
  type        = string
  default     = "Standard"
}

variable "zones" {
  description = "Optional - Specifies a list of Availability Zones in which this Azure Firewall should be located. Changing this forces a new Azure Firewall to be created."
  type        = list(number)
  default     = null
}

variable "firewall_policy_id" {
  description = "Attach an existing firewall policy to this firewall. Cannot be used in conjuction with `network_rule_collections`, `application_rule_collections` and `nat_rule_collections` variables."
  type        = string
  default     = null
}

variable "public_ip_ddos_protection_mode" {
  description = "The DDoS protection mode to use for the firewall's public address."
  type        = string
  default     = "VirtualNetworkInherited"
}

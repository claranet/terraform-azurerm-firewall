resource "azurerm_public_ip" "firewall_public_ip" {
  name                = local.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = local.public_ip_allocation_method
  sku                 = local.public_ip_sku
  zones               = var.public_ip_zones

  tags = merge(local.default_tags, var.extra_tags)
}

module "firewall_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "5.0.0"

  environment          = var.environment
  location_short       = var.location_short
  client_name          = var.client_name
  stack                = var.stack
  custom_subnet_name   = local.firewall_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_cidr_list     = [var.subnet_cidr]
}

resource "azurerm_firewall" "firewall" {
  name                = local.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.sku_tier
  ip_configuration {
    name                 = var.ip_configuration_name
    subnet_id            = module.firewall_subnet.subnet_id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }

  dynamic "ip_configuration" {
    for_each = toset(var.additional_public_ips)
    content {
      name                 = lookup(ip_configuration.value, "name")
      public_ip_address_id = lookup(ip_configuration.value, "public_ip_address_id")
    }
  }

  private_ip_ranges = var.firewall_private_ip_ranges

  dns_servers = var.dns_servers

  tags = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_firewall_network_rule_collection" "network_rule_collection" {
  for_each = try({ for collection in var.network_rule_collections : collection.name => collection }, toset([]))

  name                = each.key
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = var.resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      source_ip_groups      = rule.value.source_ip_groups
      destination_addresses = rule.value.destination_addresses
      destination_ip_groups = rule.value.destination_ip_groups
      destination_fqdns     = rule.value.destination_fqdns
      destination_ports     = rule.value.destination_ports
      protocols             = rule.value.protocols
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "application_rule_collection" {
  for_each = try({ for collection in var.application_rule_collections : collection.name => collection }, toset([]))

  name                = each.key
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = var.resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name             = rule.value.name
      source_addresses = rule.value.source_addresses
      source_ip_groups = rule.value.source_ip_groups
      target_fqdns     = rule.value.target_fqdns
      dynamic "protocol" {
        for_each = rule.value.protocols
        content {
          port = protocol.value.port
          type = protocol.value.type
        }
      }
    }
  }
}

resource "azurerm_firewall_nat_rule_collection" "nat_rule_collection" {
  for_each = try({ for collection in var.nat_rule_collections : collection.name => collection }, toset([]))

  name                = each.key
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = var.resource_group_name
  priority            = each.value.priority
  action              = each.value.action
  dynamic "rule" {
    for_each = each.value.rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      source_ip_groups      = rule.value.source_ip_groups
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
      protocols             = rule.value.protocols
    }
  }
}

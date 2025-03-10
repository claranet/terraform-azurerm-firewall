resource "azurerm_public_ip" "main" {
  name                 = local.public_ip_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  allocation_method    = local.public_ip_allocation_method
  sku                  = local.public_ip_sku
  zones                = var.public_ip_zones
  ddos_protection_mode = var.public_ip_ddos_protection_mode

  tags = merge(local.default_tags, var.extra_tags)
}

moved {
  from = azurerm_public_ip.firewall_public_ip
  to   = azurerm_public_ip.main
}

resource "azurerm_firewall" "main" {
  name                = local.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.sku_tier
  zones               = var.zones
  ip_configuration {
    name                 = var.ip_configuration_name
    subnet_id            = module.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.main.id
  }

  dynamic "ip_configuration" {
    for_each = toset(var.additional_public_ips)
    content {
      name                 = ip_configuration.value.name
      public_ip_address_id = ip_configuration.value.public_ip_address_id
    }
  }

  private_ip_ranges = var.private_ip_ranges

  firewall_policy_id = var.firewall_policy_id

  dns_servers = var.dns_servers

  tags = merge(local.default_tags, var.extra_tags)

  lifecycle {
    precondition {
      condition     = !(var.firewall_policy_id != null && (var.network_rule_collections != null || var.application_rule_collections != null || var.nat_rule_collections != null))
      error_message = "Do not use var.firewall_policy_id with var.network_rule_collections, var.application_rule_collections or var.nat_rule_collections variables. Migrate them into your policy."
    }
  }
}

moved {
  from = azurerm_firewall.firewall
  to   = azurerm_firewall.main
}

resource "azurerm_firewall_network_rule_collection" "main" {
  for_each = try({ for collection in var.network_rule_collections : collection.name => collection }, toset([]))

  name                = each.key
  azure_firewall_name = azurerm_firewall.main.name
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

moved {
  from = azurerm_firewall_network_rule_collection.network_rule_collection
  to   = azurerm_firewall_network_rule_collection.main
}

resource "azurerm_firewall_application_rule_collection" "main" {
  for_each = try({ for collection in var.application_rule_collections : collection.name => collection }, toset([]))

  name                = each.key
  azure_firewall_name = azurerm_firewall.main.name
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

moved {
  from = azurerm_firewall_application_rule_collection.application_rule_collection
  to   = azurerm_firewall_application_rule_collection.main
}

resource "azurerm_firewall_nat_rule_collection" "main" {
  for_each = try({ for collection in var.nat_rule_collections : collection.name => collection }, toset([]))

  name                = each.key
  azure_firewall_name = azurerm_firewall.main.name
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

moved {
  from = azurerm_firewall_nat_rule_collection.nat_rule_collection
  to   = azurerm_firewall_nat_rule_collection.main
}

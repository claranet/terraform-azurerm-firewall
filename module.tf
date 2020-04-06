resource "azurerm_public_ip" "firewall_public_ip" {
  count               = "${var.enabled ? 1 : 0}"
  name                = "fw-${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-pubip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "${local.public_ip_allocation_method}"
  sku                 = "${local.public_ip_sku}"

  tags = "${merge(local.default_tags, var.extra_tags)}"
}

module "azure-network-subnet" {
  source               = "git::https://git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/subnet.git?ref=v1.1.0"
  environment          = "${var.environment}"
  location_short       = "${var.location_short}"
  client_name          = "${var.client_name}"
  stack                = "${var.stack}"
  custom_subnet_names  = ["${local.firewall_subnet_name}"]
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
  subnet_cidr_list     = ["${var.subnet_cidr}"]
}

resource "azurerm_firewall" "firewall" {
  count               = "${var.enabled ? 1 : 0}"
  name                = "${coalesce(var.custom_firewall_name, "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-firewall")}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                 = "${var.ip_configuration_name}"
    subnet_id            = "${module.azure-network-subnet.subnet_ids[0]}"
    public_ip_address_id = "${azurerm_public_ip.firewall_public_ip.id}"
  }

  tags = "${merge(local.default_tags, var.extra_tags)}"
}

resource "azurerm_firewall_network_rule_collection" "network_rule_collection" {
  count               = "${(var.enabled && var.add_network_rules) ? 1 : 0}"
  name                = "${var.network_rule_collection_name}"
  azure_firewall_name = "${azurerm_firewall.firewall.name}"
  resource_group_name = "${var.resource_group_name}"
  priority            = "${var.network_rule_collection_priority}"
  action              = "${var.network_rule_collection_action}"
  rule                = "${var.network_rules}"
}

resource "azurerm_firewall_application_rule_collection" "application_rule_collection" {
  count               = "${(var.enabled && var.add_app_rules) ? 1 : 0}"
  name                = "${var.app_rule_collection_name}"
  azure_firewall_name = "${azurerm_firewall.firewall.name}"
  resource_group_name = "${var.resource_group_name}"
  priority            = "${var.app_rule_collection_priority}"
  action              = "${var.app_rule_collection_action}"
  rule                = "${var.application_rules}"
}

resource "azurerm_firewall_nat_rule_collection" "nat_rule_collection" {
  count               = "${(var.enabled && var.add_nat_rules) ? 1 : 0}"
  name                = "${var.nat_rule_collection_name}"
  azure_firewall_name = "${azurerm_firewall.firewall.name}"
  resource_group_name = "${var.resource_group_name}"
  priority            = "${var.nat_rule_collection_priority}"
  action              = "${var.nat_rule_collection_action}"
  rule                = "${var.nat_rules}"
}

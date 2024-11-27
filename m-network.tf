module "firewall_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "~> 8.0.0"

  environment    = var.environment
  location_short = var.location_short
  client_name    = var.client_name
  stack          = var.stack

  custom_name = local.firewall_subnet_name

  default_outbound_access_enabled = var.subnet_default_outbound_access_enabled

  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  cidrs                = [var.subnet_cidr]
}

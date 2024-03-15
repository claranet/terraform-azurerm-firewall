module "firewall_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "6.3.0"

  environment    = var.environment
  location_short = var.location_short
  client_name    = var.client_name
  stack          = var.stack

  custom_subnet_name = local.firewall_subnet_name

  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_cidr_list     = [var.subnet_cidr]
}

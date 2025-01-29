data "azurecaf_name" "firewall" {
  name          = var.stack
  resource_type = "azurerm_firewall"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "firewall_pip" {
  name          = var.stack
  resource_type = "azurerm_public_ip"
  prefixes      = compact(["fw", local.name_prefix])
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  separator     = "-"
}

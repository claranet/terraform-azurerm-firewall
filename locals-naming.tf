locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  name           = coalesce(var.custom_name, data.azurecaf_name.firewall.result)
  public_ip_name = coalesce(var.public_ip_custom_name, data.azurecaf_name.firewall_pip.result)

  #Name of the subnet attached to the firewall. NOTE The Subnet used for the Firewall must have the name AzureFirewallSubnet and the subnet mask must be at least /26. Source: https://www.terraform.io/docs/providers/azurerm/r/firewall.html
  firewall_subnet_name = "AzureFirewallSubnet"
}

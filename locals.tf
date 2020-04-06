locals {
  default_tags = {
    env   = "${var.environment}"
    stack = "${var.stack}"
  }

  #Name of the subnet attached to the firewall. NOTE The Subnet used for the Firewall must have the name AzureFirewallSubnet and the subnet mask must be at least /26. Source: https://www.terraform.io/docs/providers/azurerm/r/firewall.html
  firewall_subnet_name = "AzureFirewallSubnet"

  #Allocation method of the firewall's public ip. Possible values are Static or Dynamic. Note: The Public IP must have a Static allocation and Standard sku. Source: https://www.terraform.io/docs/providers/azurerm/r/firewall.html#public_ip_address_id
  public_ip_allocation_method = "Static"

  #Sku of the firewall's public ip. Accepted values are Basic and Standard. Note: The Public IP must have a Static allocation and Standard sku. Source: https://www.terraform.io/docs/providers/azurerm/r/firewall.html#public_ip_address_id
  public_ip_sku = "Standard"
}

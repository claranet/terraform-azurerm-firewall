output "id" {
  description = "Firewall generated id."
  value       = azurerm_firewall.main[*].id
}

output "name" {
  description = "Firewall name."
  value       = azurerm_firewall.main[*].name
}

output "subnet_id" {
  description = "ID of the subnet attached to the firewall."
  value       = azurerm_firewall.main[*].ip_configuration[0].subnet_id
}

output "private_ip_address" {
  description = "Firewall private IP."
  value       = azurerm_firewall.main[*].ip_configuration[0].private_ip_address
}

output "public_ip_address" {
  description = "Firewall public IP."
  value       = azurerm_public_ip.main[*].ip_address
}

output "resource" {
  description = "Azure Firewall resource object."
  value       = azurerm_firewall.main
}

output "resource_network_rule_collection" {
  description = "Azure Firewall network rule collection resource object."
  value       = azurerm_firewall_network_rule_collection.main
}

output "resource_application_rule_collection" {
  description = "Azure Firewall application rule collection resource object."
  value       = azurerm_firewall_application_rule_collection.main
}

output "resource_nat_rule_collection" {
  description = "Azure Firewall NAT rule collection resource object."
  value       = azurerm_firewall_nat_rule_collection.main
}

output "resource_public_ip" {
  description = "Azure Firewall public IP resource object."
  value       = azurerm_public_ip.main
}

output "module_subnet" {
  description = "Subnet module object."
  value       = module.firewall_subnet
}

output "diagnostic_settings" {
  description = "Diagnostic settings module object."
  value       = module.diagnostics
}
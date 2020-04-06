output "firewall_id" {
  description = "Firewall generated id"
  value       = "${azurerm_firewall.firewall.*.id}"
}

output "firewall_name" {
  description = "Firewall name"
  value       = "${azurerm_firewall.firewall.*.name}"
}

output "subnet_id" {
  description = "ID of the subnet attached to the firewall"
  value       = "${azurerm_firewall.firewall.*.ip_configuration.0.subnet_id}"
}

output "private_ip_address" {
  description = "Firewall private IP"
  value       = "${azurerm_firewall.firewall.*.ip_configuration.0.private_ip_address}"
}

output "public_ip_address" {
  description = "Firewall public IP"
  value       = "${azurerm_public_ip.firewall_public_ip.*.ip_address}"
}

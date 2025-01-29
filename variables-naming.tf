# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name."
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name."
  type        = string
  default     = ""
}

# Custom naming override
variable "custom_name" {
  description = "Optional custom firewall name."
  type        = string
  default     = ""
}

variable "ip_configuration_name" {
  description = "Name of the ip_configuration block. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/firewall.html#ip_configuration)."
  type        = string
  default     = "ip_configuration"
}

variable "public_ip_custom_name" {
  description = "Custom name for the public IP."
  type        = string
  default     = null
}

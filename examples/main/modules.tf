module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

module "logs" {
  source  = "claranet/run/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

module "firewall" {
  source  = "claranet/firewall/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.vnet.virtual_network_name
  subnet_cidr          = "10.10.0.0/22"

  network_rule_collections = [
    {
      name     = "RuleCollection1"
      priority = 100
      action   = "Allow"
      rules = [
        {
          name                  = "AllowSSHFromWorkload1ToWorkload2"
          source_addresses      = ["10.11.1.0/24"]
          destination_ports     = ["22"]
          destination_addresses = ["10.11.2.0/24"]
          protocols             = ["TCP"]
          destination_fqdns     = null
          destination_ip_groups = null
          source_ip_groups      = null
        },
        {
          name                  = "AllowRDPFromWorkload1ToWorkload2"
          source_addresses      = ["10.11.1.0/24"]
          destination_ports     = ["3389"]
          destination_addresses = ["10.11.2.0/24"]
          protocols             = ["TCP"]
          destination_fqdns     = null
          destination_ip_groups = null
          source_ip_groups      = null
        }
      ]
    }
  ]

  application_rule_collections = [
    {
      name     = "AppRuleCollection1"
      priority = 101
      action   = "Allow"
      rules = [
        {
          name             = "AllowGoogle"
          source_addresses = ["10.11.1.0/24", "10.11.2.0/24"]
          target_fqdns     = ["*.google.com", "*.google.fr"]
          source_ip_groups = null
          protocols = [
            {
              port = "443"
              type = "Https"
            },
            {
              port = "80"
              type = "Http"
            }
          ]
        }
      ]
    }
  ]
  nat_rule_collections = [
    {
      name     = "NatRuleCollection1"
      priority = 100
      action   = "Dnat"
      rules = [
        {
          name                  = "RedirectWeb"
          source_addresses      = ["*"]
          destination_ports     = ["80"]
          destination_addresses = ["x.x.x.x"] # Firewall public IP Address
          translated_port       = 80
          translated_address    = "10.10.1.4"
          protocols             = ["TCP", "UDP"]
          source_ip_groups      = null
        }
      ]
    }
  ]

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id
  ]
}

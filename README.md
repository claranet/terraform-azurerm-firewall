# Azure Firewall
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/firewall/azurerm/)

Common Azure module to generate an Azure Firewall and its dedicated subnet.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
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
  source  = "claranet/run-common/azurerm//modules/logs"
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
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.1 |
| azurerm | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | 5.0.0 |
| firewall\_subnet | claranet/subnet/azurerm | 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.firewall](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.firewall_pip](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_firewall.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_firewall_application_rule_collection.application_rule_collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_application_rule_collection) | resource |
| [azurerm_firewall_nat_rule_collection.nat_rule_collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_nat_rule_collection) | resource |
| [azurerm_firewall_network_rule_collection.network_rule_collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_network_rule_collection) | resource |
| [azurerm_public_ip.firewall_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group_template_deployment.firewall_workbook_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_public\_ips | List of additional public ips' ids to attach to the firewall. | <pre>list(object({<br>    name                 = string,<br>    public_ip_address_id = string<br>  }))</pre> | `[]` | no |
| application\_rule\_collections | Create an application rule collection | <pre>list(object({<br>    name     = string,<br>    priority = number,<br>    action   = string,<br>    rules = list(object({<br>      name             = string,<br>      source_addresses = list(string),<br>      source_ip_groups = list(string),<br>      target_fqdns     = list(string),<br>      protocols = list(object({<br>        port = string,<br>        type = string<br>      }))<br>    }))<br>  }))</pre> | `null` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_firewall\_name | Optional custom firewall name | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| deploy\_log\_workbook | Deploy Azure Workbook Log in log analytics workspace. [GitHub Azure](https://github.com/Azure/Azure-Network-Security/tree/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook) | `bool` | `true` | no |
| dns\_servers | DNS Servers to use with Azure Firewall. Using this also activate DNS Proxy. | `list(string)` | `null` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| firewall\_private\_ip\_ranges | A list of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918. | `list(string)` | `null` | no |
| ip\_configuration\_name | Name of the ip\_configuration block. https://www.terraform.io/docs/providers/azurerm/r/firewall.html#ip_configuration | `string` | `"ip_configuration"` | no |
| location | Azure region to use | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account | `number` | `30` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| nat\_rule\_collections | Create a Nat rule collection | <pre>list(object({<br>    name     = string,<br>    priority = number,<br>    action   = string,<br>    rules = list(object({<br>      name                  = string,<br>      source_addresses      = list(string),<br>      source_ip_groups      = list(string),<br>      destination_ports     = list(string),<br>      destination_addresses = list(string),<br>      translated_port       = number,<br>      translated_address    = string,<br>      protocols             = list(string)<br>    }))<br>  }))</pre> | `null` | no |
| network\_rule\_collections | Create a network rule collection | <pre>list(object({<br>    name     = string,<br>    priority = number,<br>    action   = string,<br>    rules = list(object({<br>      name                  = string,<br>      source_addresses      = list(string),<br>      source_ip_groups      = list(string),<br>      destination_ports     = list(string),<br>      destination_addresses = list(string),<br>      destination_ip_groups = list(string),<br>      destination_fqdns     = list(string),<br>      protocols             = list(string)<br>    }))<br>  }))</pre> | `null` | no |
| public\_ip\_custom\_name | Custom name for the public IP | `string` | `null` | no |
| public\_ip\_zones | Public IP zones to configure. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| sku\_tier | SKU tier of the Firewall. Possible values are `Premium` and `Standard` | `string` | `"Standard"` | no |
| stack | Project stack name | `string` | n/a | yes |
| subnet\_cidr | The address prefix to use for the firewall's subnet | `string` | n/a | yes |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| virtual\_network\_name | Name of the vnet attached to the firewall. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| firewall\_id | Firewall generated id |
| firewall\_name | Firewall name |
| private\_ip\_address | Firewall private IP |
| public\_ip\_address | Firewall public IP |
| subnet\_id | ID of the subnet attached to the firewall |
<!-- END_TF_DOCS -->
## Sources

- [docs.microsoft.com/en-us/azure/firewall/overview](https://docs.microsoft.com/en-us/azure/firewall/overview)
- [docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-deploy-portal](https://docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-deploy-portal)
- [docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-dnat](https://docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-dnat)
- [docs.microsoft.com/en-us/azure/firewall/rule-processing](https://docs.microsoft.com/en-us/azure/firewall/rule-processing)
- [docs.microsoft.com/en-us/azure/firewall/firewall-diagnostics](https://docs.microsoft.com/en-us/azure/firewall/firewall-diagnostics)
- [github.com/Azure/Azure-Network-Security/tree/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook](https://github.com/Azure/Azure-Network-Security/tree/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook)

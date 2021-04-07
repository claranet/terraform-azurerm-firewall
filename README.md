# Azure Firewall
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/firewall/azurerm/)

Common Azure module to generate an Azure Firewall and its dedicated subnet.

## Version compatibility

| Module version | Terraform version | AzureRM version |
|----------------|-------------------| --------------- |
| >= 4.x.x       | 0.13.x            | >= 2.45         |
| >= 3.x.x       | 0.12.x            | >= 2.45         |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

## Usage

```shell
module "azure-region" {
  source       = "claranet/region/azurerm"
  version      = "x.x.x"
  azure_region = var.location
}

module "rg" {
  source      = "claranet/rg/azurerm"
  version     = "x.x.x"
  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment         = var.environment
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  client_name         = var.client_name
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = var.vnet_cidr
}

module "azure-firewall" {
  source               = "claranet/firewall/azurerm"
  location             = module.azure-region.location
  location_short       = module.azure-region.location_short
  client_name          = var.client_name
  environment          = var.environment
  stack                = var.stack
  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.vnet.virtual_network_name
  subnet_cidr          = "10.10.10.0/26"

  network_rule_collections = [
    {
      name     = "RuleCollection1"
      priority = 100
      action   = "Allow"
      rules = [
        {
          name                  = "AllowSSHFromWorkload1ToWorkload2"
          source_addresses      = ["10.10.1.0/24"]
          destination_ports     = ["22"]
          destination_addresses = ["10.10.2.0/24"]
          protocols             = ["TCP"]
        },
        {
          name                  = "AllowRDPFromWorkload1ToWorkload2"
          source_addresses      = ["10.10.1.0/24"]
          destination_ports     = ["3389"]
          destination_addresses = ["10.10.2.0/24"]
          protocols             = ["TCP"]
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
          source_addresses = ["10.10.1.0/24", "10.10.2.0/24"]
          target_fqdns     = ["*.google.com", "*.google.fr"]
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
          destination_ports     = ["80", "443"]
          destination_addresses = ["x.x.x.x"] # Firewall public IP Address
          translated_port       = 80
          translated_address    = "10.10.1.4"
          protocols             = ["TCP", "UDP"]
        }
      ]
    }
  ]

  logs_destination_ids = [
    data.terraform_remote_state.run.outputs.logs_storage_account_id,
    data.terraform_remote_state.run.outputs.log_analytics_workspace_id

  ]
}
```

Example: To configure another subnet to use the firewall for outgoing traffic, add the following resources:
```shell


module "azure-network-route-table" {
  source  = "claranet/route-table/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  
  tags                = local.default_tags
}

resource "azurerm_route" "custom-route" {
  name                   = "DefaultRouteToFw"
  resource_group_name    = module.rg.resource_group_name
  route_table_name       = module.azure-network-route-table.route_table_name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.azure-firewall.private_ip_address[0]
}

module "azure-workload-subnet" {
  source               = "claranet/subnet/azurerm"
  version              = "x.x.x"
  
  environment          = local.environment
  location_short       = module.azure-region.location_short
  client_name          = local.client_name
  stack                = local.stack
  custom_subnet_names  = ["workload_subnet"]
  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.vnet.virtual_network_name
  subnet_cidr_list     = ["10.10.1.0/24"]

  route_table_ids      = [module.azure-network-route-table.route_table_id]
}

module "azure-workload-2-subnet" {
  source               = "claranet/subnet/azurerm"
  version              = "x.x.x"
  
  environment          = local.environment
  location_short       = module.azure-region.location_short
  client_name          = local.client_name
  stack                = local.stack
  custom_subnet_names  = ["workload_2_subnet"]
  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.vnet.virtual_network_name
  subnet_cidr_list     = ["10.10.2.0/24"]

  route_table_ids      = [module.azure-network-route-table.route_table_id]
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_public\_ips | List of additional public ips' ids to attach to the firewall. | <pre>list(object({<br>    name                 = string,<br>    public_ip_address_id = string<br>  }))</pre> | `[]` | no |
| application\_rule\_collections | Create an application rule collection | <pre>list(object({<br>    name     = string,<br>    priority = number,<br>    action   = string,<br>    rules = list(object({<br>      name             = string,<br>      source_addresses = list(string),<br>      source_ip_groups = list(string),<br>      target_fqdns     = list(string),<br>      protocols = list(object({<br>        port = string,<br>        type = string<br>      }))<br>    }))<br>  }))</pre> | `null` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_firewall\_name | Optional custom firewall name | `string` | `""` | no |
| deploy\_log\_workbook | Deploy Azure Workbook Log in log analytics workspace. [GitHub Azure](https://github.com/Azure/Azure-Network-Security/tree/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook) | `bool` | `true` | no |
| dns\_servers | DNS Servers to use with Azure Firewall. Using this also activate DNS Proxy. | `list(string)` | `null` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| ip\_configuration\_name | Name of the ip\_configuration block. https://www.terraform.io/docs/providers/azurerm/r/firewall.html#ip_configuration | `string` | `"ip_configuration"` | no |
| location | Azure region to use | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | List of logs categories to log | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of IDs (storage, logAnalytics Workspace, EventHub) to push logs to. | `list(string)` | `null` | no |
| logs\_metrics\_categories | List of metrics categories to log | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs. | `number` | `32` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| nat\_rule\_collections | Create a Nat rule collection | <pre>list(object({<br>    name     = string,<br>    priority = number,<br>    action   = string,<br>    rules = list(object({<br>      name                  = string,<br>      source_addresses      = list(string),<br>      source_ip_groups      = list(string),<br>      destination_ports     = list(string),<br>      destination_addresses = list(string),<br>      translated_port       = number,<br>      translated_address    = string,<br>      protocols             = list(string)<br>    }))<br>  }))</pre> | `null` | no |
| network\_rule\_collections | Create a network rule collection | <pre>list(object({<br>    name     = string,<br>    priority = number,<br>    action   = string,<br>    rules = list(object({<br>      name                  = string,<br>      source_addresses      = list(string),<br>      source_ip_groups      = list(string),<br>      destination_ports     = list(string),<br>      destination_addresses = list(string),<br>      destination_ip_groups = list(string),<br>      destination_fqdns     = list(string),<br>      protocols             = list(string)<br>    }))<br>  }))</pre> | `null` | no |
| public\_ip\_custom\_name | Custom name for the public IP | `string` | `null` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| subnet\_cidr | The address prefix to use for the firewall's subnet | `string` | n/a | yes |
| virtual\_network\_name | Name of the vnet attached to the firewall. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| firewall\_id | Firewall generated id |
| firewall\_name | Firewall name |
| private\_ip\_address | Firewall private IP |
| public\_ip\_address | Firewall public IP |

## Sources

- [registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall)
- [registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_application_rule_collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_application_rule_collection)
- [registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_network_rule_collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_network_rule_collection)
- [registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_nat_rule_collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_nat_rule_collection)
- [docs.microsoft.com/en-us/azure/firewall/overview](https://docs.microsoft.com/en-us/azure/firewall/overview)
- [docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-deploy-portal](https://docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-deploy-portal)
- [docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-dnat](https://docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-dnat)
- [docs.microsoft.com/en-us/azure/firewall/rule-processing](https://docs.microsoft.com/en-us/azure/firewall/rule-processing)
- [docs.microsoft.com/en-us/azure/firewall/firewall-diagnostics](https://docs.microsoft.com/en-us/azure/firewall/firewall-diagnostics)
-[github.com/Azure/Azure-Network-Security/tree/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook](https://github.com/Azure/Azure-Network-Security/tree/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook)

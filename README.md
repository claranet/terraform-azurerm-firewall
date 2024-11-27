# Azure Firewall
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/firewall/azurerm/)

Common Azure module to generate an Azure Firewall and its dedicated subnet.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
module "firewall" {
  source  = "claranet/firewall/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name  = module.rg.name
  virtual_network_name = module.vnet.name
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
    # module.logs.logs_storage_account_id,
    # module.logs.log_analytics_workspace_id
  ]
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | ~> 8.0.0 |
| firewall\_subnet | claranet/subnet/azurerm | ~> 8.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_firewall_application_rule_collection.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_application_rule_collection) | resource |
| [azurerm_firewall_nat_rule_collection.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_nat_rule_collection) | resource |
| [azurerm_firewall_network_rule_collection.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_network_rule_collection) | resource |
| [azurerm_public_ip.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group_template_deployment.firewall_workbook_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [azurecaf_name.firewall](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.firewall_pip](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_public\_ips | List of additional public ips' ids to attach to the firewall. | <pre>list(object({<br/>    name                 = string,<br/>    public_ip_address_id = string<br/>  }))</pre> | `[]` | no |
| application\_rule\_collections | Create an application rule collection. | <pre>list(object({<br/>    name     = string,<br/>    priority = number,<br/>    action   = string,<br/>    rules = list(object({<br/>      name             = string,<br/>      source_addresses = list(string),<br/>      source_ip_groups = list(string),<br/>      target_fqdns     = list(string),<br/>      protocols = list(object({<br/>        port = string,<br/>        type = string<br/>      }))<br/>    }))<br/>  }))</pre> | `null` | no |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_name | Optional custom firewall name. | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| deploy\_log\_workbook | Deploy Azure Workbook Log in log analytics workspace. [GitHub Azure](https://github.com/Azure/Azure-Network-Security/tree/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook). | `bool` | `true` | no |
| diagnostic\_settings\_custom\_name | Custom name of the diagnostics settings, name will be `default` if not set. | `string` | `"default"` | no |
| dns\_servers | DNS Servers to use with Azure Firewall. Using this also activate DNS Proxy. | `list(string)` | `null` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Extra tags to add. | `map(string)` | `{}` | no |
| firewall\_policy\_id | Attach an existing firewall policy to this firewall. Cannot be used in conjuction with `network_rule_collections`, `application_rule_collections` and `nat_rule_collections` variables. | `string` | `null` | no |
| ip\_configuration\_name | Name of the ip\_configuration block. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/firewall.html#ip_configuration). | `string` | `"ip_configuration"` | no |
| location | Azure region to use. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| nat\_rule\_collections | Create a Nat rule collection. | <pre>list(object({<br/>    name     = string,<br/>    priority = number,<br/>    action   = string,<br/>    rules = list(object({<br/>      name                  = string,<br/>      source_addresses      = list(string),<br/>      source_ip_groups      = list(string),<br/>      destination_ports     = list(string),<br/>      destination_addresses = list(string),<br/>      translated_port       = number,<br/>      translated_address    = string,<br/>      protocols             = list(string)<br/>    }))<br/>  }))</pre> | `null` | no |
| network\_rule\_collections | Create a network rule collection. | <pre>list(object({<br/>    name     = string,<br/>    priority = number,<br/>    action   = string,<br/>    rules = list(object({<br/>      name                  = string,<br/>      source_addresses      = list(string),<br/>      source_ip_groups      = list(string),<br/>      destination_ports     = list(string),<br/>      destination_addresses = list(string),<br/>      destination_ip_groups = list(string),<br/>      destination_fqdns     = list(string),<br/>      protocols             = list(string)<br/>    }))<br/>  }))</pre> | `null` | no |
| private\_ip\_ranges | A list of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918. | `list(string)` | `null` | no |
| public\_ip\_custom\_name | Custom name for the public IP. | `string` | `null` | no |
| public\_ip\_ddos\_protection\_mode | The DDoS protection mode to use for the firewall's public address. | `string` | `"VirtualNetworkInherited"` | no |
| public\_ip\_zones | Public IP zones to configure. | `list(number)` | <pre>[<br/>  1,<br/>  2,<br/>  3<br/>]</pre> | no |
| resource\_group\_name | Resource group name. | `string` | n/a | yes |
| sku\_tier | SKU tier of the Firewall. Possible values are `Premium` and `Standard`. | `string` | `"Standard"` | no |
| stack | Project stack name. | `string` | n/a | yes |
| subnet\_cidr | The address prefix to use for the firewall's subnet. | `string` | n/a | yes |
| subnet\_default\_outbound\_access\_enabled | Whether to allow default outbound traffic from the subnet. | `bool` | `false` | no |
| virtual\_network\_name | Name of the vnet attached to the firewall. | `string` | n/a | yes |
| zones | Optional - Specifies a list of Availability Zones in which this Azure Firewall should be located. Changing this forces a new Azure Firewall to be created. | `list(number)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| diagnostic\_settings | Diagnostic settings module object. |
| id | Firewall generated id. |
| module\_subnet | Subnet module object. |
| name | Firewall name. |
| private\_ip\_address | Firewall private IP. |
| public\_ip\_address | Firewall public IP. |
| resource | Azure Firewall resource object. |
| resource\_application\_rule\_collection | Azure Firewall application rule collection resource object. |
| resource\_nat\_rule\_collection | Azure Firewall NAT rule collection resource object. |
| resource\_network\_rule\_collection | Azure Firewall network rule collection resource object. |
| resource\_public\_ip | Azure Firewall public IP resource object. |
| subnet\_id | ID of the subnet attached to the firewall. |
<!-- END_TF_DOCS -->
## Sources

- [docs.microsoft.com/en-us/azure/firewall/overview](https://docs.microsoft.com/en-us/azure/firewall/overview)
- [docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-deploy-portal](https://docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-deploy-portal)
- [docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-dnat](https://docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-dnat)
- [docs.microsoft.com/en-us/azure/firewall/rule-processing](https://docs.microsoft.com/en-us/azure/firewall/rule-processing)
- [docs.microsoft.com/en-us/azure/firewall/firewall-diagnostics](https://docs.microsoft.com/en-us/azure/firewall/firewall-diagnostics)
- [github.com/Azure/Azure-Network-Security/tree/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook](https://github.com/Azure/Azure-Network-Security/tree/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook)

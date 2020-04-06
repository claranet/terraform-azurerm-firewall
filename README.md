# Azure Firewall

Common Azure module to generate a firewall attached to a vnet.

## Usage

```shell
module "azure-region" {
  source       = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=x.x.x"
  azure_region = "${var.location}"
}

module "rg" {
  source      = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=x.x.x"
  location    = "${module.azure-region.location}"
  client_name = "${var.client_name}"
  environment = "${var.environment}"
  stack       = "${var.stack}"
}

module "vnet" {
  source              = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/vnet.git?ref=x.x.x"
  environment         = "${var.environment}"
  location            = "${module.azure-region.location}"
  location_short      = "${module.azure-region.location_short}"
  client_name         = "${var.client_name}"
  stack               = "${var.stack}"
  resource_group_name = "${module.rg.resource_group_name}"
  vnet_cidr           = "${var.vnet_cidr}"
}

module "azure-firewall" {
  source				= "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/firewall.git?ref=x.x.x"
  location				= "${module.azure-region.location}"
  location_short			= "${module.azure-region.location_short}"
  client_name				= "${var.client_name}"
  environment				= "${var.environment}"
  stack					= "${var.stack}"
  resource_group_name			= "${module.rg.resource_group_name}"
  enabled				= "true"
  virtual_network_name			= "${module.vnet.virtual_network_name}"
  subnet_cidr				= "${var.subnet_cidr}"

  add_network_rules			= "true"
  network_rule_collection_action	= "Allow"
  network_rules				= [
    {
      name = "netrule1"
      source_addresses = ["10.0.0.0/16"]
      destination_ports = ["53"]
      destination_addresses = ["8.8.8.8","8.8.4.4"]
      protocols = ["TCP","UDP"]
    }
  ]

  add_app_rules				= "true"
  app_rule_collection_action		= "Allow"
  application_rules			= [
    {
      name = "apprule1"
      description   = "Optional rule"
      source_addresses = ["10.0.0.0/16"]
      #Either use fqdn_tags, either use target_fqdns + protocol :
      #fqdn_tags  = ["AzureBackup"]
      target_fqdns  = ["fqdn1","fqdn2"]
      protocol = [
        {
          port        = "443"
          type        = "Https"
        }
      ]
    }
  ]

  add_nat_rules				= "true"
  nat_rule_collection_action		= ["Dnat"]
  nat_rules				= [
    {
      name = "natrule1"
      source_addresses = ["0.0.0.0/0"]
      destination_ports = ["3389"]
      destination_addresses = ["40.66.60.141"]	#Use the firewall public address.
      protocols = ["TCP"]
      translated_address = "10.10.1.2"
      translated_port = "3389"
    }
  ]

  enable_logs_to_storage  = "true"
  logs_storage_account_id = "${var.logs_storage_account_id}"

  enable_logs_to_log_analytics    = "true"
  logs_log_analytics_workspace_id = "${var.log_analytics_id}"

  enable_logs_to_eventhub = "true"
  logs_eventhub_workspace_name = "${var.logs_eventhub_workspace_name}"
  logs_eventhub_authorization_rule_id = "${var.logs_eventhub_authorization_rule_id}"
 

}

```
Example: To configure another subnet to use the firewall for outgoing traffic, add the following resources:
```shell
resource "azurerm_route_table" "workload_route_table" {
  name                          = "default_route_table"
  location                      = "${module.azure-region.location}"
  resource_group_name           = "${module.rg.resource_group_name}"

  route {
    name                        = "fw-dg"
    address_prefix              = "0.0.0.0/0"
    next_hop_type               = "VirtualAppliance"
    next_hop_in_ip_address      = "${module.azure-firewall.private_ip_address[0]}"
  }

  tags = "${local.default_tags}"
}

module "azure-workload-subnet" {
  source               = "git::https://git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/subnet.git?ref=az-95-fix-routes-and-nsg-count"
  environment          = "${local.environment}"
  location_short       = "${module.azure-region.location_short}"
  client_name          = "${local.client_name}"
  stack                = "${local.stack}"
  custom_subnet_names  = ["workload_subnet"]
  resource_group_name  = "${module.rg.resource_group_name}"
  virtual_network_name = "${module.vnet.virtual_network_name}"
  subnet_cidr_list     = ["10.10.1.0/24"]

  # This list must be the same size as `subnet_cidr_list` or not set
  route_table_count    = "1"
  route_table_ids      = ["${azurerm_route_table.workload_route_table.id}"]
}

resource "azurerm_subnet_route_table_association" "route_table_association" {
  subnet_id      = "${module.azure-workload-subnet.subnet_ids[0]}"
  route_table_id = "${azurerm_route_table.workload_route_table.id}"
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| add\_app\_rules | Add an Application Rule Collection within the Azure Firewall, or not. Set to true or false. | string | `"false"` | no |
| add\_nat\_rules | Add an NAT Rule Collection within the Azure Firewall, or not. Set to true or false. | string | `"false"` | no |
| add\_network\_rules | Add a Network Rule Collection within the Azure Firewall, or not. Set to true or false. | string | `"false"` | no |
| app\_rule\_collection\_action | Specifies the action the rules will apply to matching traffic. Possible values are Allow and Deny. https://www.terraform.io/docs/providers/azurerm/r/firewall_application_rule_collection.html#action | string | `"Deny"` | no |
| app\_rule\_collection\_name | Specifies the name of the Application Rule Collection which must be unique within the Firewall. Changing this forces a new resource to be created. | string | `"app_rule_collection1"` | no |
| app\_rule\_collection\_priority | Specifies the priority of the application rule collection. Possible values are between 100 - 65000. https://www.terraform.io/docs/providers/azurerm/r/firewall_application_rule_collection.html#priority | string | `"100"` | no |
| application\_rules | A list of application rule blocks. Format: https://www.terraform.io/docs/providers/azurerm/r/firewall_application_rule_collection.html#rule . About the fqdn_tags in app rules: https://docs.microsoft.com/en-us/azure/firewall/fqdn-tags | list | `<list>` | no |
| client\_name | Client name/account used in naming | string | n/a | yes |
| custom\_firewall\_name | Optional custom firewall name | string | `""` | no |
| enable\_logs\_to\_eventhub | Boolean flag to specify whether the logs should be sent to EventHub | string | `"false"` | no |
| enable\_logs\_to\_log\_analytics | Boolean flag to specify whether the logs should be sent to Log Analytics | string | `"false"` | no |
| enable\_logs\_to\_storage | Boolean flag to specify whether the logs should be sent to the Storage Account | string | `"false"` | no |
| enabled | Set to true or false to create or not the firewall | string | `"false"` | no |
| environment | Project environment | string | n/a | yes |
| extra\_tags | Extra tags to add | map | `<map>` | no |
| ip\_configuration\_name | Name of the ip_configuration block. https://www.terraform.io/docs/providers/azurerm/r/firewall.html#ip_configuration | string | `"ip_configuration"` | no |
| location | Azure region to use | string | n/a | yes |
| location\_short | Short string for Azure location. | string | n/a | yes |
| logs\_eventhub\_authorization\_rule\_id | Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. | string | `""` | no |
| logs\_eventhub\_workspace\_name | Specifies the name of the Event Hub where Diagnostics Data should be sent. | string | `""` | no |
| logs\_log\_analytics\_workspace\_id | Log Analytics Workspace id for logs | string | `""` | no |
| logs\_storage\_account\_id | Storage Account id for logs | string | `""` | no |
| logs\_storage\_retention | Retention in days for logs on Storage Account | string | `"30"` | no |
| nat\_rule\_collection\_action | Specifies the action the rules will apply to matching traffic. Possible values are Dnat and Snat. https://www.terraform.io/docs/providers/azurerm/r/firewall_nat_rule_collection.html#action | string | `""` | no |
| nat\_rule\_collection\_name | Specifies the name of the NAT Rule Collection which must be unique within the Firewall. Changing this forces a new resource to be created. | string | `"nat_rule_collection1"` | no |
| nat\_rule\_collection\_priority | Specifies the priority of the NAT rule collection. Possible values are between 100 - 65000. https://www.terraform.io/docs/providers/azurerm/r/firewall_nat_rule_collection.html#priority | string | `"100"` | no |
| nat\_rules | A list of NAT rule blocks. Format: https://www.terraform.io/docs/providers/azurerm/r/firewall_nat_rule_collection.html#rule | list | `<list>` | no |
| network\_rule\_collection\_action | Specifies the action the rules will apply to matching traffic. Possible values are Allow and Deny. https://www.terraform.io/docs/providers/azurerm/r/firewall_network_rule_collection.html#action | string | `"Deny"` | no |
| network\_rule\_collection\_name | Specifies the name of the Network Rule Collection which must be unique within the Firewall. Changing this forces a new resource to be created. | string | `"network_rule_collection1"` | no |
| network\_rule\_collection\_priority | Specifies the priority of the rule collection. Possible values are between 100 - 65000. https://www.terraform.io/docs/providers/azurerm/r/firewall_network_rule_collection.html#priority | string | `"100"` | no |
| network\_rules | A list of network rule blocks. Format: https://www.terraform.io/docs/providers/azurerm/r/firewall_network_rule_collection.html#rule | list | `<list>` | no |
| resource\_group\_name | Resource group name | string | n/a | yes |
| stack | Project stack name | string | n/a | yes |
| subnet\_cidr | The address prefix to use for the firewall's subnet | string | n/a | yes |
| virtual\_network\_name | Name of the vnet attached to the firewall. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| firewall\_id | Firewall generated id |
| firewall\_name | Firewall name |
| private\_ip\_address | Firewall private IP |
| public\_ip\_address | Firewall public IP |
| subnet\_id | ID of the subnet attached to the firewall |


## Sources
<https://www.terraform.io/docs/providers/azurerm/r/firewall.html>\
<https://www.terraform.io/docs/providers/azurerm/r/firewall_application_rule_collection.html>\
<https://www.terraform.io/docs/providers/azurerm/r/firewall_network_rule_collection.html>\
<https://docs.microsoft.com/fr-fr/azure/firewall/overview>\
<https://docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-deploy-portal#create-a-default-route>\
<https://docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-dnat>\
<https://docs.microsoft.com/fr-fr/azure/firewall/rule-processing>\
<https://docs.microsoft.com/en-us/azure/firewall/tutorial-diagnostics>

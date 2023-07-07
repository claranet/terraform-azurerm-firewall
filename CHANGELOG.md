# v6.5.0 - 2023-07-07

Added
  * AZ-1104: Add `zones` option to deploy on availability zones

# v6.4.0 - 2023-02-10

Added
  * AZ-940: Add `firewall_policy_id` option. Cannot be used in conjuction with `network_rule_collections`, `application_rule_collections` and `nat_rule_collections`

# v6.3.1 - 2022-12-12

Fixed
  * AZ-908: Bump subnet module to 6.1.0

# v6.3.0 - 2022-11-23

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)

# v6.2.0 - 2022-09-30

Changed
  * AZ-844: Bump `subnet` module to latest version

# v6.1.0 - 2022-09-02

Added
 * AZ-832: Adding Public IP zones option and Private IPs range management

# v6.0.0 - 2022-05-20

Breaking
  * AZ-717: Bump AzureRM provider version to `v3.0+`

# v5.1.0 - 2022-04-08

Added
  * AZ-615: Add an option to enable or disable default tags

# v5.0.0 - 2022-01-13

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources

Changed
  * AZ-572: Revamp examples and improve CI

# v3.1.0/v4.1.0 - 2021-08-27

Changed
  * AZ-532: Revamp README with latest `terraform-docs` tool
  * AZ-530: Cleanup module, fix linter errors

# v3.0.0/v4.0.0 - 2021-04-07

Breaking
  * AZ-460: Rewrite module for TF 0.13+

# v1.0.0 - 2019-06-12

Added
  * AZ-36: Azure Firewall module - First Release.

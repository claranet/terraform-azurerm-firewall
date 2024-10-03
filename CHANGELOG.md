## 6.7.0 (2024-10-03)

### Features

* use Claranet "azurecaf" provider 9912774

## 6.6.1 (2024-10-01)

### Documentation

* update README badge to use OpenTofu registry a834974

### Miscellaneous Chores

* bump minimum AzureRM version 6feb451
* **deps:** update dependency claranet/subnet/azurerm to v7.1.0 83371ff
* **deps:** update dependency terraform-docs to v0.19.0 68563d4
* **deps:** update dependency tflint to v0.53.0 045815a
* **deps:** update dependency trivy to v0.55.0 dd640d4
* **deps:** update dependency trivy to v0.55.1 996b4ae
* **deps:** update dependency trivy to v0.55.2 8ecc080
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 d862705
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 8be62b6
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.2 46aa162
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.3 7d52c84
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.93.0 e9fdd16
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.0 5099ffc
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 bf4afdc
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 45591be
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 831393c
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 2ac3d81
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.1 f712311
* **deps:** update tools 4387813

## 6.6.0 (2024-08-09)


### Features

* add public ip ddos protection 5dba28f


### Bug Fixes

* **AZ-1447:** fix resource naming and lint 5bdccc6


### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] 0cca7f9
* **AZ-1391:** update semantic-release config [skip ci] 199dfd5


### Miscellaneous Chores

* **deps:** add renovate.json a98c6e0
* **deps:** enable automerge on renovate 8c4849d
* **deps:** update dependency opentofu to v1.7.0 aa0da13
* **deps:** update dependency opentofu to v1.7.1 1030e02
* **deps:** update dependency opentofu to v1.7.2 fbfd037
* **deps:** update dependency opentofu to v1.7.3 67d42c3
* **deps:** update dependency opentofu to v1.8.0 eb56667
* **deps:** update dependency opentofu to v1.8.1 ccb373a
* **deps:** update dependency pre-commit to v3.7.1 d8e950a
* **deps:** update dependency pre-commit to v3.8.0 0d3b413
* **deps:** update dependency terraform-docs to v0.18.0 09a677b
* **deps:** update dependency tflint to v0.51.0 0cdc927
* **deps:** update dependency tflint to v0.51.1 45fa3a6
* **deps:** update dependency tflint to v0.51.2 81b5992
* **deps:** update dependency tflint to v0.52.0 2e37b06
* **deps:** update dependency trivy to v0.50.2 cba52ac
* **deps:** update dependency trivy to v0.50.4 d95694e
* **deps:** update dependency trivy to v0.51.0 6dd0045
* **deps:** update dependency trivy to v0.51.1 949700a
* **deps:** update dependency trivy to v0.51.2 f4fe93e
* **deps:** update dependency trivy to v0.51.4 1b58276
* **deps:** update dependency trivy to v0.52.0 7814ec0
* **deps:** update dependency trivy to v0.52.1 3c056c6
* **deps:** update dependency trivy to v0.52.2 206e8fd
* **deps:** update dependency trivy to v0.53.0 ed109d7
* **deps:** update dependency trivy to v0.54.1 d8d693a
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 45bff65
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.1 f3ef36f
* **deps:** update renovate.json 63d5043
* **deps:** update terraform claranet/diagnostic-settings/azurerm to ~> 6.5.0 3e24fbf
* **deps:** update terraform claranet/subnet/azurerm to v6.3.0 78689f5
* **deps:** update terraform claranet/subnet/azurerm to v7 d6fca07
* **pre-commit:** update commitlint hook 593562e
* **release:** remove legacy `VERSION` file 6589fed

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

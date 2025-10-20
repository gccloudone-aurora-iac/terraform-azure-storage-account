# Terraform Azure Storage Account

Deploys and configures an Azure Storage Account.

 <!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0.0, < 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.73.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azure_resource_names"></a> [azure\_resource\_names](#module\_azure\_resource\_names) | git::https://github.com/gccloudone-aurora-iac/terraform-aurora-azure-resource-names.git | v2.0.0 |
| <a name="module_storage_account_name"></a> [storage\_account\_name](#module\_storage\_account\_name) | git::https://github.com/gccloudone-aurora-iac/terraform-aurora-azure-resource-names-global.git | v2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_resource_attributes"></a> [azure\_resource\_attributes](#input\_azure\_resource\_attributes) | Attributes used to describe Azure resources | <pre>object({<br>    project     = string<br>    environment = string<br>    location    = optional(string, "Canada Central")<br>    instance    = number<br>  })</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the Azure resource group where to locate the storage account | `string` | n/a | yes |
| <a name="input_user_defined"></a> [user\_defined](#input\_user\_defined) | The user-defined segment that describes the purpose of the Storage Account. | `string` | n/a | yes |
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot. | `string` | `"Hot"` | no |
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | Replication type of the storage account | `string` | `"LRS"` | no |
| <a name="input_allow_nested_items_to_be_public"></a> [allow\_nested\_items\_to\_be\_public](#input\_allow\_nested\_items\_to\_be\_public) | Allow or disallow nested items within this Account to opt into being public. | `bool` | `false` | no |
| <a name="input_containers"></a> [containers](#input\_containers) | List of containers to create | `list(string)` | `[]` | no |
| <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key) | The Azure Key Vault resource ID and key name used to manage a Customer Managed Key for a Storage Account. | <pre>object({<br>    key_vault_id = string<br>    key_name     = string<br>  })</pre> | `null` | no |
| <a name="input_enable_advanced_threat_protection"></a> [enable\_advanced\_threat\_protection](#input\_enable\_advanced\_threat\_protection) | Manages the Storage Account's Advanced Threat Protection setting | `bool` | `false` | no |
| <a name="input_hns_enabled"></a> [hns\_enabled](#input\_hns\_enabled) | Enable hierarchical namespace (creates Data Lake storage account) | `bool` | `false` | no |
| <a name="input_ip_rules"></a> [ip\_rules](#input\_ip\_rules) | List of IP rules for accessing the Storage Account | `list(string)` | `[]` | no |
| <a name="input_network_default_action"></a> [network\_default\_action](#input\_network\_default\_action) | Default network action to take | `string` | `"Deny"` | no |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | The name of an existing subnet to deploy and allocate private IP addresses from a virtual network. It is used to create a private endpoint between the keyvault the module creates and the specified subnet. | <pre>list(object({<br>    sub_resource_name   = string<br>    subnet_id           = optional(string)<br>    private_dns_zone_id = string<br>  }))</pre> | `[]` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether the public network access is enabled? Defaults to true. If var.private\_endpoints is set, this variable is automatically set to false. | `bool` | `false` | no |
| <a name="input_static_website"></a> [static\_website](#input\_static\_website) | Serve static content (HTML, CSS, JavaScript, and image files) directly from a storage container. | <pre>object({<br>    index_document     = string<br>    error_404_document = string<br>  })</pre> | <pre>{<br>  "error_404_document": "",<br>  "index_document": ""<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to assign to Azure resources | `map(string)` | `{}` | no |
| <a name="input_virtual_network_subnet_ids"></a> [virtual\_network\_subnet\_ids](#input\_virtual\_network\_subnet\_ids) | List of subnets to permit access to the Storage Account | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | n/a |
| <a name="output_primary_blob_endpoint"></a> [primary\_blob\_endpoint](#output\_primary\_blob\_endpoint) | n/a |
| <a name="output_private_endpoint_ids"></a> [private\_endpoint\_ids](#output\_private\_endpoint\_ids) | The Azure resource IDs of the private endpoints created. |
| <a name="output_private_endpoint_ip_config"></a> [private\_endpoint\_ip\_config](#output\_private\_endpoint\_ip\_config) | The IP configuration of the private endpoints. |
| <a name="output_secondary_access_key"></a> [secondary\_access\_key](#output\_secondary\_access\_key) | n/a |
<!-- END_TF_DOCS -->

## History

| Date       | Release | Change                                                                                                    |
| ---------- | ------- | --------------------------------------------------------------------------------------------------------- |
| 2025-01-25 | v1.0.0  | Initial v1.0.0 release                                                                                    |
| 2025-10-20 | v2.0.1  | Pin minimum version of azurerm to 4.49.0                                                                  |

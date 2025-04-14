module "storage_account_name" {
  source = "git::https://github.com/gccloudone-aurora-iac/terraform-aurora-azure-resource-names-global.git?ref=v2.0.0"

  user_defined = var.user_defined
}

resource "azurerm_storage_account" "this" {
  name                = module.storage_account_name.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.azure_resource_attributes.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier
  is_hns_enabled           = var.hns_enabled

  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  public_network_access_enabled   = var.private_endpoints == [] ? false : var.public_network_access_enabled

  dynamic "static_website" {
    for_each = var.static_website.index_document == "" ? [] : [1]
    content {
      index_document     = var.static_website.index_document == "" ? null : var.static_website.index_document
      error_404_document = var.static_website.error_404_document == "" ? null : var.static_website.error_404_document
    }
  }

  tags = local.tags
}

##############
## Security ##
##############

resource "azurerm_advanced_threat_protection" "this" {
  count = var.enable_advanced_threat_protection == true ? 1 : 0

  target_resource_id = azurerm_storage_account.this.id
  enabled            = true
}

resource "azurerm_storage_account_customer_managed_key" "this" {
  count = var.customer_managed_key != null ? 1 : 0

  storage_account_id = azurerm_storage_account.this.id
  key_vault_id       = var.customer_managed_key.key_vault_id
  key_name           = var.customer_managed_key.key_name
}

#############
## Content ##
#############

resource "azurerm_storage_container" "this" {
  for_each = toset(var.containers)

  name                  = each.value
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account_network_rules.this]
}

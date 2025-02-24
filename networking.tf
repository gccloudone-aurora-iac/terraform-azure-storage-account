resource "azurerm_storage_account_network_rules" "this" {
  storage_account_id = azurerm_storage_account.this.id

  default_action             = var.network_default_action
  virtual_network_subnet_ids = var.virtual_network_subnet_ids
  ip_rules                   = [for r in var.ip_rules : replace(r, "/32", "")]
  bypass                     = ["Logging", "Metrics", "AzureServices"]
}

# name: 2-64 characters
resource "azurerm_private_endpoint" "this" {
  for_each = { for index, endpoint in var.private_endpoints : index => endpoint }

  name                = "${module.azure_resource_prefixes.private_endpoint_prefix}-${var.user_defined}-${each.value.sub_resource_name}"
  resource_group_name = var.resource_group_name
  location            = var.azure_resource_attributes.location
  subnet_id           = each.value.subnet_id

  dynamic "private_dns_zone_group" {
    for_each = each.value.private_dns_zone_id != null ? [1] : []
    content {
      name                 = "default"
      private_dns_zone_ids = [each.value.private_dns_zone_id]
    }
  }

  private_service_connection {
    name                           = "${module.azure_resource_prefixes.private_endpoint_prefix}-${var.user_defined}-${each.value.sub_resource_name}"
    private_connection_resource_id = azurerm_storage_account.this.id
    is_manual_connection           = false
    subresource_names              = [each.value.sub_resource_name]
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}

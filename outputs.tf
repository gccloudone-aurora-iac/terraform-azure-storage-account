output "id" {
  value = azurerm_storage_account.this.id
}

output "name" {
  value = azurerm_storage_account.this.name
}

output "primary_access_key" {
  value     = azurerm_storage_account.this.primary_access_key
  sensitive = true
}

output "secondary_access_key" {
  value     = azurerm_storage_account.this.secondary_access_key
  sensitive = true
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.this.primary_blob_endpoint
}

#########################
### Private Endpoints ###
#########################

output "private_endpoint_ids" {
  description = "The Azure resource IDs of the private endpoints created."
  value = tomap({
    for k, v in azurerm_private_endpoint.this : k => v.id
  })
}

output "private_endpoint_ip_config" {
  description = "The IP configuration of the private endpoints."
  value = tomap({
    for k, v in azurerm_private_endpoint.this : k => v.id
  })
}

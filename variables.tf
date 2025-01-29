variable "azure_resource_attributes" {
  description = "Attributes used to describe Azure resources"
  type = object({
    project     = string
    environment = string
    location    = optional(string, "Canada Central")
    instance    = number
  })
  nullable = false
}

variable "user_defined" {
  description = "The user-defined segment that describes the purpose of the Storage Account."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure resource group where to locate the storage account"
  type        = string
}

variable "tags" {
  description = "List of tags to assign to Azure resources"
  type        = map(string)
  default     = {}
}

####################
### Availability ###
####################

variable "account_replication_type" {
  description = "Replication type of the storage account"
  type        = string
  default     = "LRS"
}

####################
### Blob Service ###
####################

variable "hns_enabled" {
  description = "Enable hierarchical namespace (creates Data Lake storage account)"
  type        = bool
  default     = false
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
  type        = string
  default     = "Hot"
}

variable "allow_nested_items_to_be_public" {
  description = "Allow or disallow nested items within this Account to opt into being public."
  type        = bool
  default     = false
}

##################
### Networking ###
##################

variable "public_network_access_enabled" {
  description = "Whether the public network access is enabled? Defaults to true. If var.private_endpoints is set, this variable is automatically set to false."
  type        = bool
  default     = false
}

variable "network_default_action" {
  description = "Default network action to take"
  type        = string
  default     = "Deny"
}

variable "ip_rules" {
  description = "List of IP rules for accessing the Storage Account"
  type        = list(string)
  default     = []
}

variable "virtual_network_subnet_ids" {
  description = "List of subnets to permit access to the Storage Account"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for entry in var.virtual_network_subnet_ids :
      can(regex("^/subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Network/virtualNetworks/(.+)/subnets/(.+)", entry))
    ])
    error_message = "The values for virtual_network_subnet_ids must be a valid subnet resource ID."
  }
}

variable "private_endpoints" {
  description = "The information required to create a private endpoint for the Storage Account."
  type = list(object({
    sub_resource_name   = optional(string, "blob")
    subnet_id           = string
    private_dns_zone_id = string
  }))
  default = []


  validation {
    condition = alltrue([
      for entry in var.private_endpoints :
      contains(["file", "blob", "table", "queue", "web", "dfs"], entry.sub_resource_name)
    ])
    error_message = "Invalid sub_resource_name within var.private_endpoints. Expected the name to be one of 'file', 'blob', 'table', 'queue', 'web', or 'dfs'."
  }

  validation {
    condition = alltrue([
      for entry in var.private_endpoints :
      element(split("/", entry.private_dns_zone_id), 8) == "privatelink.${entry.sub_resource_name}.core.windows.net"
    ])
    error_message = "Invalid private_dns_zone_id attribute within var.private_endpoints. Expected a Private DNS Zone with the name 'privatelink.{sub_resource_name}.core.windows.net'"
  }
}

##################
### Networking ###
##################

variable "enable_advanced_threat_protection" {
  description = "Manages the Storage Account's Advanced Threat Protection setting"
  type        = bool
  default     = false
}

variable "customer_managed_key" {
  description = "The Azure Key Vault resource ID and key name used to manage a Customer Managed Key for a Storage Account."
  type = object({
    key_vault_id = string
    key_name     = string
  })
  default = null
}

###############
### Content ###
###############

variable "containers" {
  type        = list(string)
  description = "List of containers to create"
  default     = []
}

variable "static_website" {
  description = "Serve static content (HTML, CSS, JavaScript, and image files) directly from a storage container."
  default = {
    index_document     = ""
    error_404_document = ""
  }
  type = object({
    index_document     = string
    error_404_document = string
  })
}

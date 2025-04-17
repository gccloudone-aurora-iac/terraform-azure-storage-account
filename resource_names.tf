module "azure_resource_names" {
  source = "git::https://github.com/gccloudone-aurora-iac/terraform-aurora-azure-resource-names.git?ref=v2.0.0"

  naming_convention = var.naming_convention
  user_defined      = var.user_defined

  name_attributes = var.azure_resource_attributes
}

module "storage_account_name" {
  source = "git::https://github.com/gccloudone-aurora-iac/terraform-aurora-azure-resource-names-global.git?ref=v2.0.0"

  naming_convention = var.naming_convention
  user_defined      = var.user_defined

  name_attributes = var.azure_resource_attributes
}

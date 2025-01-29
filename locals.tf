locals {
  tags = merge(
    var.tags,
    {
      ModuleName    = "terraform-azure-storage-account",
      ModuleVersion = "v1.0.0",
    }
  )
}

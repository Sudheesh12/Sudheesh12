resource "azurerm_resource_group" "sudhi-rg-01" {
  name     = var.rg_name
  location = var.location
  tags = {
    environment = local.test.environment
    cost        = local.test.cost
  }
}

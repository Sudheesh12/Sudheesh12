resource "azurerm_resource_group" "sudhi-rg01" {
  name     = "${var.prefix}-rg-${var.suffix}-1"
  location = var.allowed_location[0]
  tags     = var.prod_tags

}
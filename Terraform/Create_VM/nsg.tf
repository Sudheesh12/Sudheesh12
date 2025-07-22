resource "azurerm_network_security_group" "nsg-01" {
  name                = "${var.prefix}-nsg-${var.suffix}-01"
  resource_group_name = azurerm_resource_group.sudhi-rg01.name
  location            = azurerm_resource_group.sudhi-rg01.location
}
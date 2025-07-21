# resource "azurerm_virtual_network" "main" {
#   name                = "${var.prefix}-network"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
# }


resource "azurerm_virtual_network" "vnt-01" {
    name = "${var.prefix}-vnt-${var.suffix}-01"
    resource_group_name = azurerm_resource_group.sudhi-rg01.name
    location = azurerm_resource_group.sudhi-rg01.location
    address_space = [element(var.address_space,0)]
    tags = var.prod_tags
}

resource "azurerm_subnet" "subn-01" {
    name = "subnet1"
    resource_group_name = azurerm_resource_group.sudhi-rg01.name
    virtual_network_name = azurerm_virtual_network.vnt-01.name
    address_prefixes = [ "${element(var.address_space,1)}/${element(var.address_space,2)}" ]
  }
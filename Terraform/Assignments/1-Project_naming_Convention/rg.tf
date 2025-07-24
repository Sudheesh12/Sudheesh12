resource "azurerm_resource_group" "sudhi-rg-01" {
    name = "${local.final_name}-RG"
    location= "central india"
}